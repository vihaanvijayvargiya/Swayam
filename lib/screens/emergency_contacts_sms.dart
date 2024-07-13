import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class EmergencyContactsScreen extends StatefulWidget {
  @override
  _EmergencyContactsScreenState createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Telephony telephony = Telephony.instance;

  List<Contact> _selectedContacts = [];
  bool _loading = false;
  bool _hasEmergencyContacts = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _checkExistingContacts();
  }

  Future<void> _requestPermissions() async {
    var statusContacts = await Permission.contacts.request();
    var statusSms = await Permission.sms.request();

    if (!statusContacts.isGranted || !statusSms.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissions are required to use this feature.')),
      );
    } else if (statusContacts.isPermanentlyDenied || statusSms.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _checkExistingContacts() async {
    String userId = _auth.currentUser!.uid;

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists && userDoc.data() != null && (userDoc.data() as Map<String, dynamic>)['emergency_contacts'] != null) {
      setState(() {
        _hasEmergencyContacts = true;
      });
    }
  }

  Future<void> _pickContact({int? indexToReplace}) async {
    try {
      Contact? contact = await ContactsService.openDeviceContactPicker();

      if (contact != null && contact.phones!.isNotEmpty) {
        setState(() {
          if (indexToReplace != null) {
            _selectedContacts[indexToReplace] = contact;
          } else if (_selectedContacts.length < 4) {
            _selectedContacts.add(contact);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You can select up to 4 contacts.')),
            );
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contact does not have a phone number.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick contact: $e')),
      );
    }
  }

  void _addEmergencyContacts() async {
    String userId = _auth.currentUser!.uid;

    if (_selectedContacts.isNotEmpty) {
      setState(() {
        _loading = true;
      });

      List<Map<String, String?>> contactsToSave = _selectedContacts.map((contact) {
        return {
          'name': contact.displayName,
          'phone': contact.phones!.first.value,
        };
      }).toList();

      // Updating the Firestore document with the new list of contacts
      await _firestore.collection('users').doc(userId).set({
        'emergency_contacts': FieldValue.arrayUnion(contactsToSave),
      }, SetOptions(merge: true));

      setState(() {
        _selectedContacts.clear();
        _loading = false;
        _hasEmergencyContacts = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Emergency contacts added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one contact')),
      );
    }
  }


  void _sendSOSMessage() async {
    String userId = _auth.currentUser!.uid;

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists && userDoc.data() != null) {
      var userData = userDoc.data() as Map<String, dynamic>;
      if (userData['emergency_contacts'] != null) {
        List<String> contacts = List<String>.from(
            userData['emergency_contacts'].map((contact) => contact['phone'] as String));

        try {
          for (var recipient in contacts) {
            await telephony.sendSms(to: recipient, message: 'Emergency SOS! Please help immediately.');
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('SOS message sent successfully!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send SOS message: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No emergency contacts found. Please add some.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to retrieve user data. Please try again.')),
      );
    }
  }


  void _replaceContact(int index) async {
    await _pickContact(indexToReplace: index);
  }

  void _removeContact(int index) {
    setState(() {
      _selectedContacts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Contacts'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            if (!_hasEmergencyContacts)
              ElevatedButton.icon(
                icon: Icon(Icons.person_add),
                label: Text('Select Contacts (up to 4)'),
                onPressed: _pickContact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            SizedBox(height: 10),
            if (_selectedContacts.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _selectedContacts.map((contact) {
                  int index = _selectedContacts.indexOf(contact);
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text(contact.displayName ?? ''),
                      subtitle: Text(contact.phones!.first.value ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _replaceContact(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removeContact(index),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            SizedBox(height: 20),
            if (!_hasEmergencyContacts)
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text(_loading ? 'Adding...' : 'Add Contacts'),
                onPressed: _loading ? null : _addEmergencyContacts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            SizedBox(height: 10,),
            if (_hasEmergencyContacts)
              ElevatedButton.icon(
                icon: Icon(Icons.warning, color: Colors.teal[800],),
                label: Text('Send SOS Message',style: TextStyle(color: Colors.teal[800])),
                onPressed: _sendSOSMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4DB6AC),
                  padding: EdgeInsets.symmetric(vertical: 60),
                ),
              ),
            SizedBox(height: 50),
            if (_hasEmergencyContacts)
              ElevatedButton.icon(
                icon: Icon(Icons.edit,color: Colors.teal[800],),
                label: Text('Edit Emergency Contacts',style: TextStyle(color: Colors.teal[800])),
                onPressed: () => setState(() => _hasEmergencyContacts = false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white54,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: _firestore.collection('users').doc(_auth.currentUser!.uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var userDoc = snapshot.data!;
                  if (userDoc.exists && userDoc.data() != null) {
                    var userData = userDoc.data() as Map<String, dynamic>;
                    var emergencyContacts = userData['emergency_contacts'];
                    if (emergencyContacts != null && emergencyContacts is List) {
                      return ListView.builder(
                        itemCount: emergencyContacts.length,
                        itemBuilder: (context, index) {
                          var contact = emergencyContacts[index];
                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text(contact['name'] ?? 'Unknown'),
                              subtitle: Text(contact['phone'] ?? 'No number'),
                            ),
                          );
                        },
                      );
                    }
                  }

                  return Center(child: Text('No emergency contacts found. Please add some.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

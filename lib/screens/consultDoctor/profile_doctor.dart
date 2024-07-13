/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swayam/screens/consultDoctor/search_doctor.dart';

import 'chat_doctor.dart';

class ProfileDoctorScreen extends StatelessWidget {
  final String doctorID;
  final String currentUserID;

  const ProfileDoctorScreen({Key? key, required this.doctorID, required this.currentUserID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('doctors').doc(doctorID).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data found'));
          }
          var doctorData = snapshot.data!;
          return ProfileScreen(
            doctorData: doctorData,
            doctorID: doctorID,
            currentUserID: currentUserID,
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final DocumentSnapshot doctorData;
  final String doctorID;
  final String currentUserID;

  const ProfileScreen({required this.doctorData, required this.doctorID, required this.currentUserID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _ProfileItem(
              title: 'Name',
              subtitle: doctorData['name'],
              iconData: Icons.person,
            ),
            const SizedBox(height: 10),
            _ProfileItem(
              title: 'Email',
              subtitle: doctorData['email'],
              iconData: Icons.mail,
            ),
            const SizedBox(height: 10),
            _ProfileItem(
              title: 'Specialization',
              subtitle: doctorData['specialization'] ?? 'No specialization',
              iconData: Icons.medical_services,
            ),
            const SizedBox(height: 10),
            _ProfileItem(
              title: 'Experience',
              subtitle: doctorData['experience'],
              iconData: Icons.work,
            ),
            const SizedBox(height: 10),
            _ProfileItem(
              title: 'Description',
              subtitle: doctorData['description'],
              iconData: Icons.description,
            ),
            const SizedBox(height: 10),
            _ProfileItem(
              title: 'Degree',
              subtitle: doctorData['degree'],
              iconData: Icons.school,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDoctorScreen(
                      currentUserID: currentUserID,
                      doctorID: doctorID,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.forward),
              label: Text('Chat'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchDoctorPage(),
                  ),
                );
              },
              icon: Icon(Icons.arrow_back),
              label: Text('Search Doctor'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;

  const _ProfileItem({
    required this.title,
    required this.subtitle,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.teal.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          )
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        tileColor: Colors.white,
      ),
    );
  }
}
*/


/*
import 'package:flutter/material.dart';
import 'package:swayam/screens/consultDoctor/chat_page_doctor.dart';

class ProfileDoctor extends StatelessWidget {
  final Map<String, dynamic> doctorData;

  ProfileDoctor({required this.doctorData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor's Name
            Text(
              "${doctorData['name']}",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            // Specialization
            Text(
              "Specialization: ${doctorData['specialization']}",
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            // Degree
            Text(
              "Degree: ${doctorData['degree']}",
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            // Years of Experience
            Text(
              "Years of Experience: ${doctorData['experience']}",
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            // Description
            Text(
              "Description:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "${doctorData['description']}",
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            Spacer(),
            // Chat and Back Buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            recieverEmail: doctorData['email'],
                          ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "Chat",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[600]!),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "Back",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 */


import 'package:flutter/material.dart';
import 'package:swayam/screens/consultDoctor/chat_page_doctor.dart';

class ProfileDoctor extends StatelessWidget {
  final Map<String, dynamic> doctorData;

  ProfileDoctor({required this.doctorData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Details', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Image.network(
                doctorData['imageUrl'] ?? 'https://via.placeholder.com/300',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                height: 300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorData['specialization'] ?? 'Primary Physician',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Dr. ${doctorData['name']}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${doctorData['specialization']}, ${doctorData['currentWork']}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.chat_bubble_outline),
                          label: Text('Chat'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  recieverEmail: doctorData['email'],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.call),
                          label: Text('Call'),
                          onPressed: () {
                            // Implement call functionality
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Doctor Bio',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    doctorData['description'] ?? 'No bio available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
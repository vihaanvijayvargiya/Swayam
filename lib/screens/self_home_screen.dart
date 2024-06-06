import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swayam/screens/bmi/Score_screen.dart';
import 'package:swayam/screens/bmi/bmi_index.dart';
import 'ble/ble_screen.dart';
import 'medbot.dart';
import 'login_signup/signin_screen.dart';
import 'drawer/my_drawer_header.dart';
import 'consultDoctor/your_doctor.dart';
import 'emergency.dart';
import 'drawer/profile.dart';
import 'drawer/about.dart';
import 'drawer/notifications.dart';
import 'ECG.dart';
import 'pulse_rate.dart';
import 'spo2.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:typed_data';// Add this import for Bluetooth functionality

class SelfHomeScreen extends StatefulWidget {
  final BluetoothDevice? device; // Add this line to accept a Bluetooth device

  const SelfHomeScreen({Key? key, this.device}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<SelfHomeScreen> {
  late String _userName = '';
  late String _email = '';
  BluetoothDevice? _device; // Add this line for the Bluetooth device

  @override
  void initState() {
    super.initState();
    _getUserData();
    _device = widget.device; // Initialize the Bluetooth device
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      Map<String, dynamic> userData = documentSnapshot.data()!;
      setState(() {
        _userName = userData['username'];
        _email = user.email!;
      });
    }
  }

  var currentPage = DrawerSections.home;
  int _selectedIndex = 1;

  List<Widget> _pages() => [
    YourDoctor(),
    HomeContent(device: _device), // Pass the device to HomeContent
    Emergency(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        currentPage = DrawerSections.sarthi;
      } else if (index == 1) {
        currentPage = DrawerSections.home;
      } else if (index == 2) {
        currentPage = DrawerSections.contacts;
      }
    });
  }

  void _onDrawerItemTapped(DrawerSections section) {
    if (section == DrawerSections.logout) {
      FirebaseAuth.instance.signOut().then((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
        );
      });
    } else {
      setState(() {
        currentPage = section;
        if (section == DrawerSections.home) {
          _selectedIndex = 1;
        } else if (section == DrawerSections.sarthi) {
          _selectedIndex = 0;
        } else if (section == DrawerSections.contacts) {
          _selectedIndex = 2;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var container = _pages()[_selectedIndex];

    if (currentPage == DrawerSections.profile) {
      container = ProfilePage();
    } else if (currentPage == DrawerSections.notifications) {
      container = NotificationsPage();
    } else if (currentPage == DrawerSections.about) {
      container = AboutPage();
    } else if (currentPage == DrawerSections.logout) {
      container = LoginScreen();
    } else if (currentPage == DrawerSections.ble) {
      container = BleScreen();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Swayam",
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(
                  userName: _userName,
                  email: _email,
                ),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MedBotPage()),
            );
          },
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 3, color: Colors.teal),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(
            Icons.smart_toy,
            color: Colors.teal,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Doctor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone_sharp),
            label: 'Emergency',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        children: [
          menuItem(1, "Home", Icons.home, currentPage == DrawerSections.home),
          menuItem(2, "Profile", Icons.people_alt_outlined, currentPage == DrawerSections.profile),
          Divider(),
          menuItem(3, "Notifications", Icons.notifications_outlined, currentPage == DrawerSections.notifications),
          menuItem(4, "Emergency Service", Icons.contact_phone_sharp, currentPage == DrawerSections.contacts),
          Divider(),
          menuItem(5, "About", Icons.info, currentPage == DrawerSections.about),
          menuItem(6, "Connect Device", Icons.bluetooth, currentPage == DrawerSections.ble),
          menuItem(7, "Logout", Icons.logout, currentPage == DrawerSections.logout),
        ].map((item) => Material(child: item)).toList(), // Wrap each item with Material widget
      ),
    );
  }


  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          if (id == 1) {
            _onDrawerItemTapped(DrawerSections.home);
          } else if (id == 2) {
            _onDrawerItemTapped(DrawerSections.profile);
          } else if (id == 3) {
            _onDrawerItemTapped(DrawerSections.notifications);
          } else if (id == 4) {
            _onDrawerItemTapped(DrawerSections.contacts);
          } else if (id == 5) {
            _onDrawerItemTapped(DrawerSections.about);
          } else if (id == 6) {
            _onDrawerItemTapped(DrawerSections.ble);
          } else if (id == 7) {
            _onDrawerItemTapped(DrawerSections.logout);
          }
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  home,
  profile,
  notifications,
  contacts,
  about,
  ble,
  logout,
  sarthi, // Added Sarthi enum
}

class HomeContent extends StatefulWidget {
  final BluetoothDevice? device;

  HomeContent({this.device});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  BluetoothCharacteristic? characteristic;
  double heartRate = 0.0;
  double spo2 = 0.0;
  double ecgValue = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.device != null) {
      _discoverServices();
    }
  }

  void _discoverServices() async {
    if (widget.device == null) return;
    List<BluetoothService> services = await widget.device!.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == "0d45ee9d-5a43-46fa-8370-9651c48af2a0") {
          await characteristic.setNotifyValue(true);
          characteristic.value.listen((value) {
            setState(() {
              ecgValue = _convertToFloat(value.sublist(0, 4));
              heartRate = _convertToFloat(value.sublist(0, 4));
              spo2 = _convertToFloat(value.sublist(4, 8));
            });
          });
        }
      }
    }
  }

  double _convertToFloat(List<int> value) {
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(value));
    return byteData.getFloat32(0, Endian.little);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // ECG Widget - Half of the screen
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              height: MediaQuery.of(context).size.height * 0.4, // 40% of the screen height
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ECGScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Shadow color
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.show_chart, size: 24, color: Colors.blue), // Icon for ECG
                            SizedBox(width: 8),
                            Text(
                              'ECG',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          ecgValue != 0.0 ? 'ECG: $ecgValue' : 'The ECG from device will be shown here',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Heart Rate Widget - 1/4 of the screen
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              height: MediaQuery.of(context).size.height * 0.2, // 20% of the screen height
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PulseRateScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Shadow color
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.favorite, size: 24, color: Colors.red), // Icon for Heart Rate
                            SizedBox(width: 8),
                            Text(
                              'Heart Rate',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          heartRate != 0.0 ? 'Heart Rate: $heartRate' : 'The Heart Rate from device will be shown here',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // SPO2 Widget - 1/4 of the screen
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              height: MediaQuery.of(context).size.height * 0.2, // 20% of the screen height
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpO2Screen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Shadow color
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.bloodtype, size: 24, color: Colors.green), // Icon for SPO2
                            SizedBox(width: 8),
                            Text(
                              'SPO2',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          spo2 != 0.0 ? 'sp02: $spo2' : 'The Heart Rate from device will be shown here',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // BMI Widget - 1/4 of the screen
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              height: MediaQuery.of(context).size.height * 0.2, // 20% of the screen height
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BmiIndex()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Shadow color
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.accessibility_new, size: 24, color: Colors.teal), // Icon for BMI
                            SizedBox(width: 8),
                            Text(
                              'BMI',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Tap here to check your BMI score',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

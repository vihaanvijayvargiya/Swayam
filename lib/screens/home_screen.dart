  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
  import 'package:swayam/screens/logout.dart';
  import 'package:swayam/screens/medbot.dart';
  import 'package:swayam/screens/signin_screen.dart';
  import 'package:flutter/material.dart';
  import 'package:swayam/screens/my_drawer_header.dart';
  import 'package:swayam/screens/consultDoctor/your_doctor.dart';
  import 'emergency.dart';
  import 'profile.dart';
  import 'about.dart';
  import 'notifications.dart';
  import 'ECG.dart';
  import 'pulse_rate.dart';
  import 'spo2.dart';

  class HomeScreen extends StatefulWidget {
    const HomeScreen({Key? key}) : super(key: key);

    @override
    _HomeScreenState createState() => _HomeScreenState();
  }

  class _HomeScreenState extends State<HomeScreen> {
    late String _userName = '';
    late String _email = '';

    @override
    void initState() {
      super.initState();
      _getUserData();
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

    List<Widget> _pages = [
      YourDoctor(),
      HomeContent(),
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

    @override
    Widget build(BuildContext context) {
      var container = _pages[_selectedIndex];

      if (currentPage == DrawerSections.profile) {
        container = ProfilePage();
      } else if (currentPage == DrawerSections.notifications) {
        container = NotificationsPage();
      } else if (currentPage == DrawerSections.about) {
        container = AboutPage();
      } else if (currentPage == DrawerSections.logout) {
        container = LoginScreen();
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Swayam",
            style: TextStyle(
              color: Color(0xFF008080),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF008080)),
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
            menuItem(1, "Home", Icons.home,
                currentPage == DrawerSections.home ? true : false),
            menuItem(2, "Profile", Icons.people_alt_outlined,
                currentPage == DrawerSections.profile ? true : false),
            menuItem(3, "Notifications", Icons.notifications_outlined,
                currentPage == DrawerSections.notifications ? true : false),
            Divider(),
            menuItem(4, "Emergency Service", Icons.contact_phone_sharp,
                currentPage == DrawerSections.contacts ? true : false),
            menuItem(5, "About", Icons.info,
                currentPage == DrawerSections.about ? true : false),
            menuItem(6, "Logout", Icons.logout,
                currentPage == DrawerSections.logout ? true : false),
          ],
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
    logout,
    sarthi, // Added Sarthi enum
  }

  class HomeContent extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Column(
        children: [
          // ECG Widget - Half of the screen
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ECGScreen()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10.0),
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
                          Icon(Icons.show_chart, size: 24,color: Colors.blue,), // Icon for ECG
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
                        'The ECG from device will be shown here',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Heart Rate Widget - 1/4 of the screen
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PulseRateScreen()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10.0),
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
                          Icon(Icons.favorite, size: 24,color: Colors.red,), // Icon for Heart Rate
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
                        'The heart rate from device will be shown here',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // SpO2 Widget - 1/4 of the screen
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpO2Screen()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10.0),
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
                          Icon(Icons.opacity, size: 24,color: Colors.green,), // Icon for SpO2
                          SizedBox(width: 8),
                          Text(
                            'SpO2',
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
                        'The SpO2 from device will be shown here',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

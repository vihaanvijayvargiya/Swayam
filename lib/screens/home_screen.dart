import 'package:firebase_auth/firebase_auth.dart';
import 'package:swayam/screens/logout.dart';
import 'package:swayam/screens/medbot.dart'; // Make sure this import is correct
import 'package:swayam/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:swayam/screens/my_drawer_header.dart';
import 'emergency.dart';
import 'profile.dart';
import 'about.dart';
import 'notifications.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentPage = DrawerSections.home;
  int _selectedIndex = 1;

  List<Widget> _pages = [
    MedBotPage(),
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
        backgroundColor: Color(0xFF008080),
        title: Text(
          "Swayam",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Sarthi',
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
    return Center(
      child: Text('Home Content'),
    );
  }
}

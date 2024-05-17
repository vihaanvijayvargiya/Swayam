import 'package:flutter/material.dart';
import 'package:swayam/screens/emergency.dart';
import 'package:swayam/screens/medbot.dart';
import 'package:swayam/screens/my_drawer_header.dart';
import 'package:swayam/screens/about.dart';
import 'package:swayam/screens/notifications.dart';
import 'package:swayam/screens/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentPage = DrawerSections.home;
  int _selectedIndex = 1; // Set initial index to Home

  static List<Widget> _widgetOptions = <Widget>[
    MedBotPage(),
    HomeContent(),
    Emergency(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          currentPage = DrawerSections.medbot;
          break;
        case 1:
          currentPage = DrawerSections.home;
          break;
        case 2:
          currentPage = DrawerSections.contacts;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: _widgetOptions.elementAt(_selectedIndex),
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
            icon: Icon(Icons.chat),
            label: 'Med Bot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Emergency',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
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
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.home;
              _selectedIndex = 1;
            } else if (id == 2) {
              currentPage = DrawerSections.profile;
              _selectedIndex = 2;
            } else if (id == 3) {
              currentPage = DrawerSections.notifications;
            } else if (id == 4) {
              currentPage = DrawerSections.contacts;
              _selectedIndex = 0;
            } else if (id == 5) {
              currentPage = DrawerSections.about;
            } else if (id == 6) {
              currentPage = DrawerSections.logout;
            }
          });
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
  logout, medbot,
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Home Content'),
    );
  }
}

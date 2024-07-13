import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHeaderDrawer extends StatelessWidget {
  final String userName;
  final String email;
  final String imageUrl;

  const MyHeaderDrawer({
    required this.userName,
    required this.email,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Building MyHeaderDrawer with imageUrl: $imageUrl");

    return Container(
      color: Colors.teal,
      width: double.infinity,
      height: 250, // Increase height to give more space for the image
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Align content to the start (top)
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0), // Adjust padding as needed
              child: Container(
                height: 100, // Increase size
                width: 100,
                child: _buildProfileImage(),
              ),
            ),
          ),
          Text(
            userName,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            email,
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (imageUrl.isEmpty) {
      print("MyHeaderDrawer - Using default image");
      return CircleAvatar(
        radius: 50, // Adjust the radius to match the size
        backgroundImage: AssetImage('assets/images/user.png'),
      );
    }

    return CircleAvatar(
      radius: 50, // Adjust the radius to match the size
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (exception, stackTrace) {
        print("Error loading image: $exception");
        // You can set a state here to use a fallback image if needed
      },
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover, // Ensure the image covers the avatar's bounds
          alignment: Alignment.topCenter,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}

class MyDrawerHeaderScreen extends StatefulWidget {
  const MyDrawerHeaderScreen({Key? key}) : super(key: key);

  @override
  _MyDrawerHeaderState createState() => _MyDrawerHeaderState();
}

class _MyDrawerHeaderState extends State<MyDrawerHeaderScreen> {
  String _userName = '';
  String _email = '';
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        Map<String, dynamic>? userData = documentSnapshot.data();
        if (userData != null) {
          setState(() {
            _userName = userData['username'] ?? 'User';
            _email = user.email ?? 'No email';
            _imageUrl = userData['imageUrl'] ?? '';
            print("_getUserData - Fetched userData: $userData");
            print("_getUserData - Fetched imageUrl: $_imageUrl");
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            MyHeaderDrawer(
              userName: _userName,
              email: _email,
              imageUrl: _imageUrl,
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Navigate to profile page
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings page
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                // Navigate to login page
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}

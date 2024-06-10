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
    return Container(
      color: Colors.teal,
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : AssetImage('assets/images/user.png') as ImageProvider,
                fit: BoxFit.cover,
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
}

class MyDrawerHeaderScreen extends StatefulWidget {
  const MyDrawerHeaderScreen({Key? key}) : super(key: key);

  @override
  _MyDrawerHeader createState() => _MyDrawerHeader();
}

class _MyDrawerHeader extends State<MyDrawerHeaderScreen> {
  late String _userName = '';
  late String _email = '';
  late String _imageUrl = '';

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
        _imageUrl = userData['imageUrl'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            MyHeaderDrawer(
              userName: _userName,
              email: _email,
              imageUrl: _imageUrl,
            ),
            // Other drawer items
          ],
        ),
      ),
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _getUserData(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(uid).get();
      return documentSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Center(
            child: Text(
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      body: user != null
          ? FutureBuilder<Map<String, dynamic>?>(
        future: _getUserData(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Snapshot error: ${snapshot.error}');
            return Center(child: Text('Error loading profile data'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            print('No profile data found for user');
            return Center(child: Text('No profile data found'));
          }

          Map<String, dynamic> userData = snapshot.data!;
          print('User data: $userData');
          return ProfileScreen(userData: userData, userEmail: user.email ?? '');
        },
      )
          : Center(
        child: Text('No user is signed in'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String userEmail;

  const ProfileScreen({
    required this.userData,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            if (userData.containsKey('photoURL') && userData['photoURL'] != null)
              CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(userData['photoURL']),
              ),
            const SizedBox(height: 20),
            _ProfileItem(title: 'Name', subtitle: userData['username'], iconData: Icons.person),
            const SizedBox(height: 10),
            _ProfileItem(title: 'Email', subtitle: userEmail, iconData: Icons.mail),
            const SizedBox(height: 10),
            _ProfileItem(title: 'Weight', subtitle: '${userData['weight'] ?? 'N/A'}', iconData: Icons.fitness_center),
            const SizedBox(height: 10),
            _ProfileItem(title: 'Height', subtitle: '${userData['height'] ?? 'N/A'}', iconData: Icons.height),
            const SizedBox(height: 10),
            _ProfileItem(title: 'Age', subtitle: '${userData['age'] ?? 'N/A'}', iconData: Icons.calendar_today),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text('Edit Profile'),
              ),
            )
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
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }
}

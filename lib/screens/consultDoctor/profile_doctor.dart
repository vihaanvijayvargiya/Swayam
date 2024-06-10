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
        future: FirebaseFirestore.instance.collection('users').doc(doctorID).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data found'));
          }
          var doctorData = snapshot.data!;
          return ProfileScreen(doctorData: doctorData, doctorID: doctorID, currentUserID: currentUserID,);
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
            /*
            if (doctorData['userImage'] != null)
              CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(doctorData['userImage']),
              ),
            const SizedBox(height: 20),

             */
            _ProfileItem(title: 'Name', subtitle: doctorData['name'], iconData: Icons.person),
            const SizedBox(height: 10),
            _ProfileItem(title: 'Email', subtitle: doctorData['email'], iconData: Icons.mail),
            const SizedBox(height: 10),
            _ProfileItem(title: 'Specialization', subtitle: doctorData['specialization'] ?? 'No specialization', iconData: Icons.medical_services),
            const SizedBox(height: 10),
            _ProfileItem(title: 'Experience', subtitle: doctorData['experience'], iconData: Icons.work),
            const SizedBox(height: 10),
            _ProfileItem(title: 'Description', subtitle: doctorData['description'], iconData: Icons.description),
            const SizedBox(height: 10),
            _ProfileItem(title: 'Degree', subtitle: doctorData['degree'], iconData: Icons.school),
            const SizedBox(height: 10),
            // Buttons
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDoctorScreen(currentUserID: currentUserID, doctorID: doctorID),
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


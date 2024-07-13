/*
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_doctor.dart';

class SearchDoctorPage extends StatefulWidget {
  const SearchDoctorPage({Key? key}) : super(key: key);

  @override
  State<SearchDoctorPage> createState() => _SearchDoctorPageState();
}

class _SearchDoctorPageState extends State<SearchDoctorPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;
  List<QueryDocumentSnapshot>? doctors;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
    fetchDoctors();
  }

  getCurrentUserIdandName() async {
    user = FirebaseAuth.instance.currentUser;
    userName = await getUserName();
  }

  Future<String> getUserName() async {
    if (user != null) {
      await user!.reload(); // Refresh the user data to ensure the latest display name is fetched
      user = FirebaseAuth.instance.currentUser; // Refresh the user object
      return user!.displayName ?? "NoName"; // Return the display name if available, or a default value
    } else {
      return "NoName"; // Return a default value if the user is not signed in
    }
  }

  fetchDoctors() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .get();
    setState(() {
      doctors = snapshot.docs;
      isLoading = false;
    });
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('name', isGreaterThanOrEqualTo: searchController.text)
          .get();
      setState(() {
        searchSnapshot = snapshot;
        isLoading = false;
        hasUserSearched = true;
      });
    }
  }

  Widget doctorList() {
    return doctors != null
        ? ListView.builder(
      shrinkWrap: true,
      itemCount: doctors!.length,
      itemBuilder: (context, index) {
        var doctor = doctors![index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(
              doctor['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(doctor['specialization']),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                doctor['name'][0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileDoctorScreen(
                    currentUserID: user!.uid,
                    doctorID: doctor.id,
                  ),
                ),
              );
            },
          ),
        );
      },
    )
        : Container();
  }

  Widget searchResultList() {
    return hasUserSearched && searchSnapshot != null
        ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot!.docs.length,
      itemBuilder: (context, index) {
        var doctor = searchSnapshot!.docs[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(
              doctor['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(doctor['specialization']),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                doctor['name'][0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileDoctorScreen(
                    currentUserID: user!.uid,
                    doctorID: doctor.id,
                  ),
                ),
              );
            },
          ),
        );
      },
    )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: const Center(
          child: Text(
            "Search Doctor",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20), // Add spacing between title and search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.06), // Use a transparent white for a subtle background
              borderRadius: BorderRadius.circular(25), // Circular border radius
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(color: Colors.teal), // Teal text color
                    cursorColor: Colors.teal, // Teal cursor color
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search doctors...",
                      hintStyle: TextStyle(color: Colors.teal.withOpacity(0.7)), // Lighter teal for hint text
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.7), // Semi-transparent teal for button background
                      borderRadius: BorderRadius.circular(20), // Circular button shape
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.white, // White icon color for better visibility
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40), // Add spacing between search bar and list
          isLoading
              ? Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
              : Expanded(
            child: hasUserSearched ? searchResultList() : doctorList(),
          ),
        ],
      ),
    );
  }
}
*/
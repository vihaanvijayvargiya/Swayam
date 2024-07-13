import 'package:flutter/material.dart';
import 'package:swayam/screens/consultPatient/chat_service.dart';
import 'package:swayam/screens/consultPatient/user_tile.dart';
import 'package:swayam/resources/AuthMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swayam/widgets/textfield.dart';
import 'chat_page.dart';

class ChatNav extends StatefulWidget {
  @override
  _ChatNavState createState() => _ChatNavState();
}

class _ChatNavState extends State<ChatNav> {
  final ChatService _chatService = ChatService();
  final AuthMethods _authMethods = AuthMethods();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSearchBar(),
          ),
        ),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value.toLowerCase();
        });
      },
      decoration: InputDecoration(
        hintText: 'Search self users...',
        prefixIcon: Icon(Icons.search, color: Colors.teal),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      cursorColor: Colors.teal,
      style: TextStyle(color: Colors.black),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("Error fetching user information"));
        }

        List<Map<String, dynamic>> usersData = snapshot.data!;
        User? currentUser = _authMethods.getCurrentUser();
        String currentUserEmail = currentUser?.email ?? '';

        usersData = usersData.where((user) {
          String email = user['email'] ?? '';
          String userType = user['userType'] ?? '';
          return email != currentUserEmail && email.toLowerCase().contains(_searchQuery) && userType == 'Self';
        }).toList();

        if (usersData.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        return ListView(
          children: usersData.map<Widget>((userData) => _buildUserItem(userData, context)).toList(),
        );
      },
    );
  }

  Widget _buildUserItem(Map<String, dynamic> userData, BuildContext context) {
    String name = userData["name"] ?? 'No name';
    String profileImageUrl = userData["imageUrl"] ?? '';
    return UserTile(
      name: name,
      profileImageUrl: profileImageUrl,
      onTap: () {
        if (name != 'No name') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverEmail: userData["email"],
              ),
            ),
          );
        } else {
          print("Invalid name"); // Logging invalid name cases
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:swayam/screens/consultPatient/chat_service.dart';
import 'package:swayam/screens/consultPatient/user_tile.dart';


import 'package:swayam/resources/AuthMethods.dart';

import 'chat_page.dart';



class ChatNav extends StatelessWidget {
  final ChatService _chatService = ChatService();
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        centerTitle: true,
      ),
      body: _buildUserList(),
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

        return ListView(
          children: usersData
              .map<Widget>((userData) => _buildUserItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserItem(Map<String, dynamic> userData, BuildContext context) {
    String email = userData["email"] ?? 'No email';
    return UserTile(
      text: email,
      onTap: () {
        if (email != 'No email') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverEmail: userData["email"],

              ),
            ),
          );
        } else {
          print("Invalid email address"); // Logging invalid email cases
        }
      },
    );
  }
}

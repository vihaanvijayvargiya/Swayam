import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swayam/screens/consultPatient/chat_service.dart';
import 'package:swayam/resources/AuthMethods.dart';
import 'package:swayam/widgets/textfield.dart';

class ChatPage extends StatelessWidget {
  final String recieverEmail;

  ChatPage({
    Key? key,
    required this.recieverEmail,
  }) : super(key: key);

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthMethods _authMethods = AuthMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    String currentUserId = _auth.currentUser!.uid;
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(recieverEmail, _messageController.text);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(recieverEmail,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }


  Widget _buildMessageList() {
    String currentUserEmail = _auth.currentUser!.email ?? '';
    return StreamBuilder(
      stream: _chatService.getMessage(recieverEmail, currentUserEmail),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No messages"));
        }

        List<DocumentSnapshot> messages = snapshot.data!.docs;
        messages.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
        messages = messages.reversed.toList();

        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data = messages[index].data() as Map<String, dynamic>;
            bool isSentByCurrentUser = data['senderEmail'] == _auth.currentUser!.email;
            return _buildMessageItem(data, isSentByCurrentUser);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> data, bool isSentByCurrentUser) {
    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate();

    return Align(
      alignment: isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSentByCurrentUser ? Colors.teal : Colors.grey[300],
          borderRadius: BorderRadius.circular(8).subtract(
            BorderRadius.only(
              topLeft: isSentByCurrentUser ? Radius.circular(8) : Radius.zero,
              topRight: isSentByCurrentUser ? Radius.zero : Radius.circular(8),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['message'],
              style: TextStyle(
                color: isSentByCurrentUser ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${dateTime.hour}:${dateTime.minute}',
              style: TextStyle(
                fontSize: 12,
                color: isSentByCurrentUser ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildUserInput() {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: InputText(
              hint: "Enter text",
              icon: Icon(Icons.message_rounded),
              controller: _messageController,
              textInputType: TextInputType.text,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: Icon(Icons.send),
            color: Colors.teal,
          ),
        ],
      ),
    );
  }
}

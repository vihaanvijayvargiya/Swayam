import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatDoctorScreen extends StatefulWidget {
  final String currentUserID;
  final String doctorID;

  const ChatDoctorScreen({required this.currentUserID, required this.doctorID, Key? key}) : super(key: key);

  @override
  _ChatDoctorScreenState createState() => _ChatDoctorScreenState();
}

class _ChatDoctorScreenState extends State<ChatDoctorScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  String messageText = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void sendMessage() async {
    if (messageText.isNotEmpty) {
      await _firestore.collection('chats').doc(widget.currentUserID).collection('doctorChats').doc(widget.doctorID).collection('messages').add({
        'text': messageText,
        'sender': widget.currentUserID,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('chats').doc(widget.doctorID).collection('patientChats').doc(widget.currentUserID).collection('messages').add({
        'text': messageText,
        'sender': widget.currentUserID,
        'timestamp': FieldValue.serverTimestamp(),
      });

      messageText = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MessagesStream(currentUserID: widget.currentUserID, doctorID: widget.doctorID),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      messageText = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final String currentUserID;
  final String doctorID;

  MessagesStream({required this.currentUserID, required this.doctorID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('chats').doc(currentUserID).collection('doctorChats').doc(doctorID).collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final messages = snapshot.data!.docs;
        List<MessageBubble> messageWidgets = [];
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];
          final isSelf = messageSender == currentUserID;
          final messageWidget = MessageBubble(
            sender: messageSender,
            text: messageText,
            isSelf: isSelf,
          );
          messageWidgets.add(messageWidget);
        }
        return ListView(
          reverse: true,
          children: messageWidgets,
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isSelf;

  MessageBubble({required this.sender, required this.text, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: isSelf ? Radius.circular(30.0) : Radius.circular(0.0),
              topRight: isSelf ? Radius.circular(0.0) : Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isSelf ? Colors.lightBlueAccent : Colors.grey[300],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

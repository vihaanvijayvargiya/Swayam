import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swayam/screens/consultPatient/message.dart';


class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        print('User data: $user'); // Logging user data for debugging
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverEmail, String message) async {
    try {
      String currentUserEmail = _auth.currentUser!.email ?? '';

      Message newMessage = Message(

        senderEmail: currentUserEmail,
        recieverEmail: receiverEmail,
        message: message,
        timestamp: Timestamp.now(),
      );

      List<String> ids = [currentUserEmail, receiverEmail];
      ids.sort();
      String chatRoomID = ids.join('_');

      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .add(newMessage.toMap());
    } catch (e) {
      print('Error sending message: $e');
      throw e; // Rethrow the error for handling in UI if needed
    }
  }

  Stream<QuerySnapshot> getMessage(String userEmail, String otherUserEmail) {
    List<String> ids = [userEmail, otherUserEmail];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}

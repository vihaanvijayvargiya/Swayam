import 'package:cloud_firestore/cloud_firestore.dart';


class Message {

  final String senderEmail;
  final String recieverEmail;
  final String message;
  final Timestamp timestamp;

  Message({

    required this.senderEmail,
    required this.recieverEmail,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {

      'senderEmail': senderEmail,
      'recieverEmail': recieverEmail,
      'message': message,
      'timestamp': timestamp,
    };
  }
}

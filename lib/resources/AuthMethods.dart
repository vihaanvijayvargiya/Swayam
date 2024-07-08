import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String name,
    required String dob,
    required String mobile,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && name.isNotEmpty && dob.isNotEmpty && mobile.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        Map<String, dynamic> userData = {
          'username': username,
          'email': email,
          'name': name,
          'dob': dob,
          'mobile': mobile,
        };

        await _firestore.collection('users').doc(cred.user!.uid).set(userData);

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> res = {"status": "Some error occurred"};
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;
        if (user != null) {
          DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
          if (userDoc.exists) {
            res = {
              "status": "success",
              "userData": userDoc.data(),
            };
          } else {
            res["status"] = "User document does not exist";
          }
        }
      } else {
        res["status"] = "Please enter all the fields";
      }
    } catch (err) {
      res["status"] = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

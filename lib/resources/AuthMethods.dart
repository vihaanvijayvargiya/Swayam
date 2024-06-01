import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String weight,
    required String height,
    required String age,
    required String userType,
  }) async {
    String res = "Some error occurred";
    try {
      if (userType.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          weight.isNotEmpty &&
          height.isNotEmpty &&
          age.isNotEmpty) {

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await _firestore.collection("users").doc(cred.user!.uid).set({
          'userType': userType,
          'username': username,
          'email': email,
          'weight': weight,
          'height': height,
          'age': age,
        });

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
          res = {
            "status": "success",
            "userType": userDoc['userType'],
          };
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

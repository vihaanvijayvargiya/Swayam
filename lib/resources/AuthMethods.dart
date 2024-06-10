import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> _verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(FirebaseAuthException e) onVerificationFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: onVerificationFailed,
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
        Fluttertoast.showToast(msg: "OTP sent to your mobile number");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> _verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      Fluttertoast.showToast(msg: "Mobile number verified");
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid OTP");
    }
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String name,
    required String dob,
    String? weight,
    String? height,
    required String mobile,
    required String userType,
    String? experience,
    String? description,
    String? specialization,
    String? currentWork,
    String? degree,
    String? degreeYear,
    String? degreePdfUrl,
    required String imageUrl,

  }) async {
    String res = "Some error occurred";
    try {
      if (userType.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          name.isNotEmpty &&
          dob.isNotEmpty &&
          imageUrl.isNotEmpty &&
          mobile.isNotEmpty ) {

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        Map<String, dynamic> userData = {
          'userType': userType,
          'username': username,
          'email': email,
          'name': name,
          'dob': dob,
          'mobile': mobile,
          'imageUrl': imageUrl,

        };

        if (userType == 'Self') {
          userData.addAll({
            'weight': weight,
            'height': height,
          });
        } else if (userType == 'Doctor') {
          userData.addAll({
            'experience': experience,
            'description': description,
            'specialization': specialization,
            'currentWork': currentWork,
            'degree': degree,
            'degreeYear': degreeYear,
            'degreePdfUrl': degreePdfUrl,
          });
        }

        await _firestore.collection("users").doc(cred.user!.uid).set(userData);

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

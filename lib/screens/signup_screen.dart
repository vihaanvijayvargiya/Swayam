import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swayam/screens/home_screen.dart';
import 'package:swayam/screens/signin_screen.dart';

import '../resources/AuthMethods.dart';
import '../widgets/textfield.dart';




class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); // Add controller for confirm password
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
  }

  void signUpUser() async {
    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      Fluttertoast.showToast(msg: "Passwords do not match");
      return;
    }

    // set loading to true
    setState(() {
      _isLoading = true;
    });


    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        );
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        Fluttertoast.showToast(msg: res);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > 600
              ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/swayam.png'),
              const SizedBox(
                height: 24,
              ),
              InputText(
                hint: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                controller: _emailController,
                icon: Icon(Icons.email),
              ),
              const SizedBox(
                height: 24,
              ),
              InputText(
                hint: 'Create username',
                textInputType: TextInputType.text,
                controller: _usernameController,
                icon: Icon(Icons.person),
              ),
              const SizedBox(
                height: 24,
              ),
              InputText(
                hint: 'Create password',
                textInputType: TextInputType.text,
                controller: _passwordController,
                icon: Icon(Icons.password),
                ispass:true,

              ),
              const SizedBox(
                height: 24,
              ),
              InputText(
                hint: 'Confirm password',
                textInputType: TextInputType.text,
                controller: _confirmPasswordController,
                icon: Icon(Icons.password),
                ispass:true,

              ),
              const SizedBox(
                height: 24,
              ),

              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: Colors.deepPurple,
                  ),
                  child: !_isLoading
                      ? const Text(
                    'Sign up',style: TextStyle(fontSize: 20,color: Colors.white),
                  )
                      : const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Already have an account?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Login.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }



}

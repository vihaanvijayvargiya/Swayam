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
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
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
      weight: _weightController.text,
      height: _heightController.text,
      age: _ageController.text,
    );
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
        );
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
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > 600
              ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 300,
                    child: Image.asset('assets/images/swayam.png')),
                Text('Swayam', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: Color(0x018D8DFF)),),
                SizedBox(height: 20,),
                InputText(
                  hint: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  controller: _emailController,
                  icon: Icon(Icons.email, color: Colors.grey[800]),
                ),
                const SizedBox(
                  height: 24,
                ),
                InputText(
                  hint: 'Create username',
                  textInputType: TextInputType.text,
                  controller: _usernameController,
                  icon: Icon(Icons.person, color: Colors.grey[800]),
                ),
                const SizedBox(
                  height: 24,
                ),
                InputText(
                  hint: 'Create password',
                  textInputType: TextInputType.text,
                  controller: _passwordController,
                  icon: Icon(Icons.password, color: Colors.grey[800]),
                  ispass: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                InputText(
                  hint: 'Confirm password',
                  textInputType: TextInputType.text,
                  controller: _confirmPasswordController,
                  icon: Icon(Icons.password, color: Colors.grey[800]),
                  ispass: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                InputText(
                  hint: 'Enter Weight',
                  textInputType: TextInputType.number,
                  controller: _weightController,
                  icon: Icon(Icons.fitness_center, color: Colors.grey[800]),
                ),
                const SizedBox(
                  height: 24,
                ),
                InputText(
                  hint: 'Enter Height in cm',
                  textInputType: TextInputType.number,
                  controller: _heightController,
                  icon: Icon(Icons.height, color: Colors.grey[800]),
                ),
                const SizedBox(
                  height: 24,
                ),
                InputText(
                  hint: 'Enter Age',
                  textInputType: TextInputType.number,
                  controller: _ageController,
                  icon: Icon(Icons.cake, color: Colors.grey[800]),
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      color: Color(0xFF008080),
                    ),
                    child: !_isLoading
                        ? const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 20, color: Colors.white),
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
                              color: Color(0xFF008080)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

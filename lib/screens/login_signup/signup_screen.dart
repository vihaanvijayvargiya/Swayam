import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swayam/screens/login_signup/signin_screen.dart';
import 'package:swayam/screens/self_home_screen.dart';
import '../../resources/AuthMethods.dart';
import '../../widgets/textfield.dart';
import '../home_screen.dart';

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
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;
  String? _selectedUserType;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    _mobileController.dispose();
    _nameController.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: Colors.teal, // Selected date color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = picked.toString().substring(0, 10); // Formatting the date as YYYY-MM-DD
      });
    }
  }

  void signUpUser() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      Fluttertoast.showToast(msg: "Passwords do not match");
      return;
    }

    if (_emailController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _mobileController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      name: _nameController.text,
      dob: _dobController.text,
      mobile: _mobileController.text,
    );

    if (res == "success") {
      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SelfHomeScreen()),
              (route) => false,
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
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
                  child: Image.asset('assets/images/swayam.png'),
                ),
                Text(
                  'Swayam',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: Color(0x018D8DFF)),
                ),
                SizedBox(height: 20),
                InputText(
                  hint: 'Enter your name',
                  textInputType: TextInputType.name,
                  controller: _nameController,
                  icon: Icon(Icons.person, color: Colors.grey[800]),
                ),
                SizedBox(height: 24),
                InputText(
                  hint: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  controller: _emailController,
                  icon: Icon(Icons.email, color: Colors.grey[800]),
                ),
                SizedBox(height: 24),
                InputText(
                  hint: 'Create username',
                  textInputType: TextInputType.text,
                  controller: _usernameController,
                  icon: Icon(Icons.person, color: Colors.grey[800]),
                ),
                SizedBox(height: 24),
                InputText(
                  hint: 'Create password',
                  textInputType: TextInputType.text,
                  controller: _passwordController,
                  icon: Icon(Icons.password, color: Colors.grey[800]),
                  ispass: true,
                ),
                SizedBox(height: 24),
                InputText(
                  hint: 'Confirm password',
                  textInputType: TextInputType.text,
                  controller: _confirmPasswordController,
                  icon: Icon(Icons.password, color: Colors.grey[800]),
                  ispass: true,
                ),
                SizedBox(height: 24),
                InputText(
                  hint: 'Enter Date of Birth',
                  textInputType: TextInputType.datetime,
                  controller: _dobController,
                  icon: Icon(Icons.cake, color: Colors.grey[800]),
                  onTap: () => _selectDate(context),
                ),
                SizedBox(height: 24),
                InputText(
                  hint: 'Enter Mobile No',
                  textInputType: TextInputType.phone,
                  controller: _mobileController,
                  icon: Icon(Icons.phone, color: Colors.grey[800]),
                ),
                SizedBox(height: 24),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      color: Color(0xFF008080),
                    ),
                    child: !_isLoading
                        ? Text(
                      'Sign up',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                        : CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
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
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
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
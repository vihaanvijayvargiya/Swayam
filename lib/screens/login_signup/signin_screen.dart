/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swayam/screens/home_screen.dart';
import 'package:swayam/screens/login_signup/signup_screen.dart';
import 'package:swayam/screens/self_home_screen.dart';

import '../../resources/AuthMethods.dart';
import '../../widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      _isLoading = false;
    });

    if (res['status'] == 'success') {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SelfHomeScreen()),
              (route) => false,
        );
      }
    } else {
      if (context.mounted) {
        Fluttertoast.showToast(msg: res['status']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > 600
              ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 350,
                    child: Image.asset('assets/images/swayam.png')),
                Text(
                  'Swayam',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: Color(0x018D8DFF)),
                ),
                SizedBox(height: 20),
                InputText(
                  hint: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  controller: _emailController,
                  icon: Icon(Icons.person),
                ),
                const SizedBox(
                  height: 24,
                ),
                InputText(
                  hint: 'Enter your password',
                  textInputType: TextInputType.text,
                  controller: _passwordController,
                  ispass: true,
                  icon: Icon(Icons.password),
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: loginUser,
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
                      'Log in',
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
                        'Dont have an account?',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          ' Signup.',
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

 */

/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swayam/screens/home_screen.dart';
import 'package:swayam/screens/login_signup/signup_screen.dart';

import '../../resources/AuthMethods.dart';
import '../../widgets/textfield.dart';
import '../self_home_screen.dart';
import '../doctor_home_screen.dart';  // Import the respective home screens

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res['status'] == 'success') {
      if (context.mounted) {
        Widget homeScreen;
        if (res['userType'] == 'Self') {
          homeScreen = SelfHomeScreen();
        } else if (res['userType'] == 'Doctor') {
          homeScreen = DoctorHomeScreen();
        } else {
          homeScreen = HomeScreen();  // Default home screen if userType is unknown
        }

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => homeScreen), (route) => false);

        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        Fluttertoast.showToast(msg: res['status']);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > 600
              ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(Icons.person_outline,size: 150,color: Colors.grey[800],),
                Container(
                    height: 350,
                    child: Image.asset('assets/images/swayam.png')),
                Text('Swayam'
                    '',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 30,color: Color(0x018D8DFF)),),
                SizedBox(height: 20,),
                InputText(
                  hint: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  controller: _emailController,
                  icon: Icon(Icons.person),
                ),
                const SizedBox(
                  height: 24,
                ),
                InputText(
                  hint: 'Enter your password',
                  textInputType: TextInputType.text,
                  controller: _passwordController,
                  ispass: true,
                  icon: Icon(Icons.password),
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: loginUser,
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
                      'Log in',style: TextStyle(color: Colors.white,fontSize: 20),
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
                        'Dont have an account?',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          ' Signup.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,color: Color(0xFF008080)
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
      ),
    );
  }
}
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swayam/screens/login_signup/signup_screen.dart';
import '../../resources/AuthMethods.dart';
import '../../widgets/textfield.dart';
import '../self_home_screen.dart';
import '../doctor_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedUserType; // No default value
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    if (_selectedUserType == null) {
      Fluttertoast.showToast(msg: "Please select a user type");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (res['status'] == 'success') {
      if (_selectedUserType == res['userType']) {
        if (context.mounted) {
          Widget homeScreen;
          if (res['userType'] == 'Self') {
            homeScreen = SelfHomeScreen();
          } else if (res['userType'] == 'Doctor') {
            homeScreen = DoctorHomeScreen();
          } else {
            // This case shouldn't occur as we are only dealing with 'Self' and 'Doctor'
            Fluttertoast.showToast(msg: "Unexpected user type");
            return;
          }

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => homeScreen),
                (route) => false,
          );
        }
      } else {
        Fluttertoast.showToast(msg: "The selected user type does not match the registered user type.");
      }
    } else {
      Fluttertoast.showToast(msg: res['status']);
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
                  height: 350,
                  child: Image.asset('assets/images/anahata.png'),
                ),
                Text(
                  'Anahata',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: Color(0xFF018D8D)),
                ),
                SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: _selectedUserType,
                  items: ['Self', 'Doctor'].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: TextStyle(
                          color: _selectedUserType == category ? Colors.teal : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedUserType = newValue;
                    });
                  },
                  dropdownColor: Colors.white,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Select User Type',
                    prefixIcon: Icon(Icons.person, color: Colors.grey[800]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),

                const SizedBox(height: 24),
                InputText(
                  hint: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  controller: _emailController,
                  icon: Icon(Icons.person),
                ),
                const SizedBox(height: 24),
                InputText(
                  hint: 'Enter your password',
                  textInputType: TextInputType.text,
                  controller: _passwordController,
                  ispass: true,
                  icon: Icon(Icons.password),
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: loginUser,
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
                      'LogIn',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                        : const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('Don\'t have an account?'),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          ' Signup.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Color(0xFF008080)),
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

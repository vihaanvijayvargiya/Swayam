/*
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

 */


/*
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swayam/screens/login_signup/signin_screen.dart';
import 'dart:io';
import '../../resources/AuthMethods.dart';
import '../../widgets/textfield.dart';
import '../home_screen.dart';
import '../self_home_screen.dart';
import '../doctor_home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _userTypeController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _currentWorkController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _degreeYearController = TextEditingController();
  File? _degreePdfFile;
  /*
  File? _userImageFile;
  String imageUrl = '';
  */



  bool _isLoading = false;
  String? _selectedUserType;
  String _verificationId = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    _userTypeController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    _experienceController.dispose();
    _descriptionController.dispose();
    _specializationController.dispose();
    _currentWorkController.dispose();
    _degreeController.dispose();
    _degreeYearController.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    // Initialize the ImagePicker
    ImagePicker imagePicker = ImagePicker();

    // Pick an image from gallery
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('${file?.path}');

    if (file == null) return;

    // Generate a unique file name
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Get a reference to the root of Firebase Storage
    Reference referenceRoot = FirebaseStorage.instance.ref();

    // Create a reference for the directory 'images'
    Reference referenceDirImages = referenceRoot.child('images');

    // Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      // Store the file
      await referenceImageToUpload.putFile(File(file.path));

      // Success: get the download URL
      String downloadUrl = await referenceImageToUpload.getDownloadURL();

      // Update the state with the new imageUrl
      setState(() {
        // imageUrl = downloadUrl;
      });

      // print('Image uploaded successfully. URL: $imageUrl');
    } catch (error) {
      // Handle errors
      print('Error uploading image: $error');
    }
  }


  Future<void> _pickPdf() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _degreePdfFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91${_mobileController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(msg: e.message ?? "Verification failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        Fluttertoast.showToast(msg: "OTP sent to your mobile number");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      forceResendingToken: 10,
      timeout: const Duration(seconds: 60),
      // Remove this line in production
    );
  }

  Future<void> _verifyOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );
      await _auth.signInWithCredential(credential);
      Fluttertoast.showToast(msg: "Mobile number verified");
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid OTP");
    }
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

    /*

    if ((_selectedUserType == 'Self' && !_usernameController.text.startsWith('S')) ||
        (_selectedUserType == 'Doctor' && !_usernameController.text.startsWith('D'))) {
      Fluttertoast.showToast(msg: "Username must start with ${_selectedUserType == 'Self' ? 'S_' : 'D_'}");
      return;
    }

     */

    // Check if all required fields are filled
    if (_selectedUserType == 'Self' && (
        _emailController.text.isEmpty || _usernameController.text.isEmpty ||
            _passwordController.text.isEmpty || _dobController.text.isEmpty ||
            _weightController.text.isEmpty || _heightController.text.isEmpty ||
            _mobileController.text.isEmpty /*|| _userImageFile == null */)) {
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }

    if (_selectedUserType == 'Doctor' && (
        _emailController.text.isEmpty || _usernameController.text.isEmpty ||
            _passwordController.text.isEmpty || _dobController.text.isEmpty ||
            _experienceController.text.isEmpty || _descriptionController.text.isEmpty ||
            _specializationController.text.isEmpty || _currentWorkController.text.isEmpty ||
            _degreeController.text.isEmpty || _degreeYearController.text.isEmpty ||
            _mobileController.text.isEmpty || _degreePdfFile == null /* || _userImageFile == null */)) {

      print("Doctor User - Missing Fields Detected");
      print("Email: ${_emailController.text}");
      print("Username: ${_usernameController.text}");
      print("Password: ${_passwordController.text}");
      print("DOB: ${_dobController.text}");
      print("Experience: ${_experienceController.text}");
      print("Description: ${_descriptionController.text}");
      print("Specialization: ${_specializationController.text}");
      print("Current Work: ${_currentWorkController.text}");
      print("Degree: ${_degreeController.text}");
      print("Degree Year: ${_degreeYearController.text}");
      print("Mobile: ${_mobileController.text}");
      print("Degree PDF: ${_degreePdfFile != null}");
      /*
      print("User Image File: $_userImageFile");
      print("Image URL: $imageUrl");
       */

      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      userType: _selectedUserType!,
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      name: _nameController.text,
      dob: _dobController.text,
      weight: _weightController.text,
      height: _heightController.text,
      mobile: _mobileController.text,
      experience: _experienceController.text,
      description: _descriptionController.text,
      specialization: _specializationController.text,
      currentWork: _currentWorkController.text,
      degree: _degreeController.text,
      degreeYear: _degreeYearController.text,
      degreePdfUrl: _degreePdfFile?.path,
      // imageUrl: imageUrl,

    );

    if (res == "success") {
      setState(() {
        _isLoading = false;
      });



      if (context.mounted) {
        Widget homeScreen;
        if (_selectedUserType == 'Self') {
          homeScreen = SelfHomeScreen();
        } else if (_selectedUserType == 'Doctor') {
          homeScreen = DoctorHomeScreen();
        } else {
          homeScreen = HomeScreen();
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => homeScreen),
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
                    child: Image.asset('assets/images/anahata.png')),
                Text('Swayam', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: Color(0x018D8DFF)),),
                SizedBox(height: 20,),
                Container(
                  color: Colors.white,
                  child: DropdownButtonFormField<String>(
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
                ),

                const SizedBox(
                  height: 24,
                ),
                InputText(
                  hint: 'Enter your name',
                  textInputType: TextInputType.name,
                  controller: _nameController,
                  icon: Icon(Icons.person, color: Colors.grey[800]),
                ),
                const SizedBox(
                  height: 24,
                ),
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
                /*
                if (_selectedUserType != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _selectedUserType == 'Self'
                          ? 'Username must start with S_'
                          : 'Username must start with D_',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 12,
                      ),
                    ),
                  ),

                 */
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
                  hint: 'Enter Date of Birth',
                  textInputType: TextInputType.datetime,
                  controller: _dobController,
                  icon: Icon(Icons.cake, color: Colors.grey[800]),
                  onTap: () => _selectDate(context),
                ),

                const SizedBox(
                  height: 24,
                ),
                if (_selectedUserType == 'Self') ...[
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
                ],
                if (_selectedUserType == 'Doctor') ...[
                  InputText(
                    hint: 'Years of Experience',
                    textInputType: TextInputType.number,
                    controller: _experienceController,
                    icon: Icon(Icons.work, color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InputText(
                    hint: 'Short Description (max 50 words)',
                    textInputType: TextInputType.text,
                    controller: _descriptionController,
                    icon: Icon(Icons.description, color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InputText(
                    hint: 'Specialization',
                    textInputType: TextInputType.text,
                    controller: _specializationController,
                    icon: Icon(Icons.local_hospital, color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InputText(
                    hint: 'Currently working as',
                    textInputType: TextInputType.text,
                    controller: _currentWorkController,
                    icon: Icon(Icons.work_outline, color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InputText(
                    hint: 'Degree',
                    textInputType: TextInputType.text,
                    controller: _degreeController,
                    icon: Icon(Icons.school, color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InputText(
                    hint: 'Year Degree Achieved',
                    textInputType: TextInputType.number,
                    controller: _degreeYearController,
                    icon: Icon(Icons.calendar_today, color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    onPressed: _pickPdf,
                    child: Text('Upload Degree PDF'),
                  ),
                  if (_degreePdfFile != null) Text('Degree PDF selected'),
                ],
                const SizedBox(
                  height: 24,
                ),
                InputText(
                  hint: 'Enter Mobile No',
                  textInputType: TextInputType.phone,
                  controller: _mobileController,
                  icon: Icon(Icons.phone, color: Colors.grey[800]),
                ),
                const SizedBox(
                  height: 24,
                ),
                /*
                ElevatedButton(
                  onPressed: _verifyPhoneNumber,
                  child: Text('Verify Mobile No'),
                ),
                const SizedBox(
                  height: 24,
                ),
                InputText(
                  hint: 'Enter OTP',
                  textInputType: TextInputType.number,
                  controller: _otpController,
                  icon: Icon(Icons.confirmation_number, color: Colors.grey[800]),
                ),
                ElevatedButton(
                  onPressed: _verifyOTP,
                  child: Text('Verify OTP'),
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  onPressed: _pickAndUploadImage,
                  child: Text('Upload Profile Image'),

                ),
                if (_userImageFile != null) Image.file(_userImageFile!, height: 100, width: 100),
                imageUrl.isNotEmpty
                    ? Image.network(imageUrl)
                    : Text('No image uploaded yet'),
                const SizedBox(
                  height: 24,
                ),
                 */

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
*/


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swayam/screens/login_signup/signin_screen.dart';
import 'dart:io';
import '../../resources/AuthMethods.dart';
import '../../widgets/textfield.dart';
import '../home_screen.dart';
import '../self_home_screen.dart';
import '../doctor_home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _userTypeController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _currentWorkController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _degreeYearController = TextEditingController();
  File? _degreePdfFile;
  File? _userImageFile;
  String imageUrl = '';




  bool _isLoading = false;
  String? _selectedUserType;
  String _verificationId = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    _userTypeController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    _experienceController.dispose();
    _descriptionController.dispose();
    _specializationController.dispose();
    _currentWorkController.dispose();
    _degreeController.dispose();
    _degreeYearController.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    // Initialize the ImagePicker
    ImagePicker imagePicker = ImagePicker();

    // Pick an image from gallery
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('${file?.path}');

    if (file == null) return;

    // Generate a unique file name
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Get a reference to the root of Firebase Storage
    Reference referenceRoot = FirebaseStorage.instance.ref();

    // Create a reference for the directory 'images'
    Reference referenceDirImages = referenceRoot.child('images');

    // Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      // Store the file
      await referenceImageToUpload.putFile(File(file.path));

      //Success: get the download URL
      String downloadUrl = await referenceImageToUpload.getDownloadURL();

      // Update the state with the new imageUrl
      setState(() {
        imageUrl = downloadUrl;
      });

      print('Image uploaded successfully. URL: $imageUrl');
    } catch (error) {
      // Handle errors
      print('Error uploading image: $error');
    }
  }


  Future<void> _pickPdf() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _degreePdfFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91${_mobileController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(msg: e.message ?? "Verification failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        Fluttertoast.showToast(msg: "OTP sent to your mobile number");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      forceResendingToken: 10,
      timeout: const Duration(seconds: 60),
      // Remove this line in production
    );
  }

  Future<void> _verifyOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );
      await _auth.signInWithCredential(credential);
      Fluttertoast.showToast(msg: "Mobile number verified");
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid OTP");
    }
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

    /*

    if ((_selectedUserType == 'Self' && !_usernameController.text.startsWith('S')) ||
        (_selectedUserType == 'Doctor' && !_usernameController.text.startsWith('D'))) {
      Fluttertoast.showToast(msg: "Username must start with ${_selectedUserType == 'Self' ? 'S_' : 'D_'}");
      return;
    }

     */

    // Check if all required fields are filled
    if (_selectedUserType == 'Self' && (
        _emailController.text.isEmpty || _usernameController.text.isEmpty ||
            _passwordController.text.isEmpty || _dobController.text.isEmpty ||
            _weightController.text.isEmpty || _heightController.text.isEmpty ||
            _mobileController.text.isEmpty || imageUrl.isEmpty )) {
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }

    if (_selectedUserType == 'Doctor' && (
        _emailController.text.isEmpty || _usernameController.text.isEmpty ||
            _passwordController.text.isEmpty || _dobController.text.isEmpty ||
            _experienceController.text.isEmpty || _descriptionController.text.isEmpty ||
            _specializationController.text.isEmpty || _currentWorkController.text.isEmpty ||
            _degreeController.text.isEmpty || _degreeYearController.text.isEmpty ||
            _mobileController.text.isEmpty || _degreePdfFile == null || imageUrl.isEmpty )) {

      print("Doctor User - Missing Fields Detected");
      print("Email: ${_emailController.text}");
      print("Username: ${_usernameController.text}");
      print("Password: ${_passwordController.text}");
      print("DOB: ${_dobController.text}");
      print("Experience: ${_experienceController.text}");
      print("Description: ${_descriptionController.text}");
      print("Specialization: ${_specializationController.text}");
      print("Current Work: ${_currentWorkController.text}");
      print("Degree: ${_degreeController.text}");
      print("Degree Year: ${_degreeYearController.text}");
      print("Mobile: ${_mobileController.text}");
      print("Degree PDF: ${_degreePdfFile != null}");

      print("User Image File: $_userImageFile");
      print("Image URL: $imageUrl");


      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      userType: _selectedUserType!,
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      name: _nameController.text,
      dob: _dobController.text,
      weight: _weightController.text,
      height: _heightController.text,
      mobile: _mobileController.text,
      experience: _experienceController.text,
      description: _descriptionController.text,
      specialization: _specializationController.text,
      currentWork: _currentWorkController.text,
      degree: _degreeController.text,
      degreeYear: _degreeYearController.text,
      degreePdfUrl: _degreePdfFile?.path,
      imageUrl: imageUrl,

    );

    if (res == "success") {
      setState(() {
        _isLoading = false;
      });



      if (context.mounted) {
        Widget homeScreen;
        if (_selectedUserType == 'Self') {
          homeScreen = SelfHomeScreen();
        } else if (_selectedUserType == 'Doctor') {
          homeScreen = DoctorHomeScreen();
        } else {
          homeScreen = HomeScreen();
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => homeScreen),
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
                    child: Image.asset('assets/images/anahata.png')),

                Text(
                  'Anahata',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: Colors.teal),
                ),
                SizedBox(height: 20),

                GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: ClipOval(
                    child: Container(
                      height: 150, // Increased size
                      width: 150,  // Increased size
                      child: _userImageFile != null
                          ? Image.file(
                        _userImageFile!,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter, // Focus on the top center
                      )
                          : imageUrl.isNotEmpty
                          ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter, // Focus on the top center
                      )
                          : Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.grey[800],
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),


                Container(
                  color: Colors.white,
                  child: DropdownButtonFormField<String>(
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
                ),


                const SizedBox(
                  height: 24,
                ),
                InputText(
                  hint: 'Enter your name',
                  textInputType: TextInputType.name,
                  controller: _nameController,
                  icon: Icon(Icons.person, color: Colors.grey[800]),
                ),
                const SizedBox(
                  height: 24,
                ),
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
                /*
                if (_selectedUserType != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _selectedUserType == 'Self'
                          ? 'Username must start with S_'
                          : 'Username must start with D_',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 12,
                      ),
                    ),
                  ),

                 */
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
                  hint: 'Enter Date of Birth',
                  textInputType: TextInputType.datetime,
                  controller: _dobController,
                  icon: Icon(Icons.cake, color: Colors.grey[800]),
                  onTap: () => _selectDate(context),
                ),

                const SizedBox(
                  height: 24,
                ),
                if (_selectedUserType == 'Self') ...[
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
                ],
                if (_selectedUserType == 'Doctor') ...[
                  InputText(
                    hint: 'Years of Experience',
                    textInputType: TextInputType.number,
                    controller: _experienceController,
                    icon: Icon(Icons.work, color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InputText(
                    hint: 'Short Description (max 50 words)',
                    textInputType: TextInputType.text,
                    controller: _descriptionController,
                    icon: Icon(Icons.description, color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InputText(
                    hint: 'Specialization',
                    textInputType: TextInputType.text,
                    controller: _specializationController,
                    icon: Icon(Icons.local_hospital, color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InputText(
                    hint: 'Currently working as',
                    textInputType: TextInputType.text,
                    controller: _currentWorkController,
                    icon: Icon(Icons.work_outline, color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InputText(
                    hint: 'Degree',
                    textInputType: TextInputType.text,
                    controller: _degreeController,
                    icon: Icon(Icons.school, color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InputText(
                    hint: 'Year Degree Achieved',
                    textInputType: TextInputType.number,
                    controller: _degreeYearController,
                    icon: Icon(Icons.calendar_today, color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    onPressed: _pickPdf,
                    child: Text('Upload Degree PDF'),
                  ),
                  if (_degreePdfFile != null) Text('Degree PDF selected'),
                ],
                const SizedBox(
                  height: 24,
                ),
                InputText(
                  hint: 'Enter Mobile No',
                  textInputType: TextInputType.phone,
                  controller: _mobileController,
                  icon: Icon(Icons.phone, color: Colors.grey[800]),
                ),
                const SizedBox(
                  height: 24,
                ),
                /*
                ElevatedButton(
                  onPressed: _verifyPhoneNumber,
                  child: Text('Verify Mobile No'),
                ),
                const SizedBox(
                  height: 24,
                ),
                InputText(
                  hint: 'Enter OTP',
                  textInputType: TextInputType.number,
                  controller: _otpController,
                  icon: Icon(Icons.confirmation_number, color: Colors.grey[800]),
                ),
                ElevatedButton(
                  onPressed: _verifyOTP,
                  child: Text('Verify OTP'),
                ),
                const SizedBox(
                  height: 24,
                ),



                ElevatedButton(
                  onPressed: _pickAndUploadImage,
                  child: Text('Upload Profile Image'),

                ),
                if (_userImageFile != null) Image.file(_userImageFile!, height: 100, width: 100),
                imageUrl.isNotEmpty
                    ? Image.network(imageUrl)
                    : Text('No image uploaded yet'),
                const SizedBox(
                  height: 24,
                ),

                 */


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

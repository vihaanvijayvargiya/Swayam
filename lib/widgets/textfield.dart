import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String hint;
  final Icon icon;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool ispass;
  final VoidCallback? onTap;

  const InputText({
    Key? key,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.textInputType,
    this.ispass = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      controller: controller,
      keyboardType: textInputType,
      obscureText: ispass,
      cursorColor: Colors.teal, // Set the cursor color to teal
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white, // Background color remains white
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), // Circular shape
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.teal, width: 2), // Teal color when focused
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      style: TextStyle(color: Colors.black), // Text color
    );
  }
}

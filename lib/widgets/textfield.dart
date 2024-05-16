import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String hint ;
  final Icon icon;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool ispass ;
  const InputText({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.textInputType,
    this.ispass=false
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          label: Text(hint),
          border: inputBorder,
          contentPadding: EdgeInsets.all(8)
      ),
      keyboardType: textInputType,
      obscureText: ispass ? true : false,
    );
  }
}
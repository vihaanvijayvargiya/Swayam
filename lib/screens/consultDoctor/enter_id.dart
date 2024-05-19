import 'package:flutter/material.dart';

class EnterIdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter ID'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Predefined number for now
            // Navigate to YourDoctor screen
            Navigator.pop(context);
          },
          child: Text('Submit'),
        ),
      ),
    );
  }
}

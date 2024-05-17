import 'package:flutter/material.dart';

class MedBotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Center(
            child: Text(
              'Sarthi - Medical Bot',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to Med Bot! This is where you can interact with our medical chatbot.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}

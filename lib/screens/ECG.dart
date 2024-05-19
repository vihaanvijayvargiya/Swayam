// ECG.dart
import 'package:flutter/material.dart';

class ECGScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ECG Screen'),
      ),
      body: Center(
        child: Text('ECG data will be displayed here'),
      ),
    );
  }
}

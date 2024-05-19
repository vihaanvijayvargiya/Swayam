import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'enter_id.dart';
import 'nearby_doctors.dart';

class YourDoctor extends StatefulWidget {
  const YourDoctor({super.key});

  @override
  State<YourDoctor> createState() => _YourDoctorState();
}

class _YourDoctorState extends State<YourDoctor> {
  bool _hasSelectedDoctor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Center(
            child: Text(
              'Your Doctor',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: _hasSelectedDoctor
            ? _buildEndSessionButton()
            : _buildInitialOptions(),
      ),
    );
  }

  Widget _buildInitialOptions() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EnterIdScreen()),
            );
          },
          child: Text('Enter the ID'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NearbyDoctorsScreen()),
            );
          },
          child: Text('Nearby Doctors'),
        ),
      ],
    );
  }

  Widget _buildEndSessionButton() {
    return Column(
      children: [
        Expanded(
          child: Text(
            'This app is still in developing stage.',
            style: TextStyle(fontSize: 24),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _hasSelectedDoctor = false;
            });
          },
          child: Text('End session with this doctor'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Swayam',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Swayam – your personal health guardian. Swayam is like having a smart assistant that keeps an eye on your heart, blood pressure, and oxygen levels all the time. It quickly detects any issues and notifies you and your doctor immediately. Our user-friendly app tracks your health over time, making health management easy and smart.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Our Mission',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Keep you healthy and alert. Using smart technology, it monitors your vital signs round the clock.It is like having a personal health guardian in your pocket, ensuring you stay ahead of health surprises.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}

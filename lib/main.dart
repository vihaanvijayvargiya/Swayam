import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swayam/screens/ble/foreground_task_handler.dart';
import 'package:swayam/screens/self_home_screen.dart';
import 'package:swayam/screens/doctor_home_screen.dart'; // Import the doctor home screen
import 'package:swayam/screens/login_signup/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:swayam/screens/home_screen.dart'; // Import the default home screen
import 'package:flutter_foreground_task/flutter_foreground_task.dart'; // Import foreground task

import 'firebase_options.dart';
// Import the foreground task handler

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.bluetooth.request();
  await Permission.locationWhenInUse.request();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize FlutterForegroundTask without await
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'foreground_service',
      channelName: 'Foreground Service Notification',
      channelDescription: 'This notification appears when the foreground service is running.',
      channelImportance: NotificationChannelImportance.LOW,
      priority: NotificationPriority.LOW,
      iconData: const NotificationIconData(
        resType: ResourceType.mipmap,
        resPrefix: ResourcePrefix.ic,
        name: 'launcher',
      ),
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: const ForegroundTaskOptions(
      interval: 5000,
      isOnceEvent: false,
      autoRunOnBoot: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swayam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.done) {
                    if (userSnapshot.hasData && userSnapshot.data != null) {
                      var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                      if (userData != null && userData.containsKey('userType')) {
                        var userType = userData['userType'];
                        if (userType == 'Self') {
                          return SelfHomeScreen();
                        } else if (userType == 'Doctor') {
                          return DoctorHomeScreen();
                        } else {
                          return HomeScreen();  // Default home screen
                        }
                      } else {
                        // Log the data for debugging
                        print("User data: $userData");
                        return Center(child: Text('User type not specified'));
                      }
                    } else {
                      return Center(child: Text('No user data found'));
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('An error occurred'));
            }
          }
          return LoginScreen();
        },
      ),
    );
  }
}

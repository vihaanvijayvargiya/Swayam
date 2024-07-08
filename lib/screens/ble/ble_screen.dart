import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:swayam/screens/ECG.dart';
import 'package:swayam/screens/self_home_screen.dart';
import 'package:swayam/screens/drawer/my_drawer_header.dart';
import 'ble_controller.dart';
import '../pulse_rate.dart';// Import the PulseRateScreen
import '../ECG.dart';

class BleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: GetBuilder<BleController>(
        init: BleController(),
        builder: (BleController controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<List<ScanResult>>(
                  stream: controller.flutterBlue.scanResults,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index];
                            return Card(
                              elevation: 2,
                              child: ListTile(
                                title: Text(data.device.name),
                                subtitle: Text(data.device.id.id),
                                trailing: Text(data.rssi.toString()),
                                onTap: () async {
                                  await controller.connectToDevice(data.device);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SelfHomeScreen(device: data.device),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(child: Text("No Device Found"));
                    }
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await controller.scanDevices();
                  },
                  child: Text(
                    "SCAN",
                    style: TextStyle(
                      color: Colors.teal, // Change this to your desired text color
                      fontSize: 16, // Change this to your desired text size
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(120, 50), // Change the width and height as needed
                  ),
                )

              ],
            ),
          );
        },
      ),
    );
  }
}

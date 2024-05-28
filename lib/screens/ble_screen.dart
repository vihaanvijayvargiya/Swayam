import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'ble_controller.dart';

class BleScreen extends StatelessWidget {
  final BleController bleController = Get.put(BleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect to ESP32'),
      ),
      body: GetBuilder<BleController>(
        init: BleController(),
        builder: (BleController controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<List<ScanResult>>(
                    stream: FlutterBluePlus.scanResults,
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
                                    title: Text(data.device.platformName),
                                    subtitle: Text(data.device.id.id),
                                    trailing: Text(data.rssi.toString()),
                                    onTap: () async {
                                      await controller.connectToDevice(data.device);
                                      Navigator.pushNamed(
                                        context,
                                        '/pulse_rate',
                                        arguments: data.device,
                                      );
                                    },
                                  ),
                                );
                              }),
                        );
                      } else {
                        return Center(child: Text("No Device Found"));
                      }
                    }),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    controller.scanDevices();
                  },
                  child: Text("SCAN"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

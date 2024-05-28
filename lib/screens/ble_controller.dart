import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  var scanResults = <ScanResult>[].obs;

  // Scan for nearby BLE devices
  Future<void> scanDevices() async {
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted) {
      // Start scanning
      FlutterBluePlus.startScan(timeout: Duration(seconds: 15));  // Accessing static method correctly

      // Listen to scan results
      FlutterBluePlus.scanResults.listen((results) {  // Accessing static property correctly
        scanResults.value = results;
      });

      // Wait for 15 seconds and stop scanning
      await Future.delayed(Duration(seconds: 15));
      FlutterBluePlus.stopScan();  // Accessing static method correctly
    }
  }

  // Connect to a BLE device
  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect(timeout: Duration(seconds: 15));

    device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.connecting) {
        print("Connecting to ${device.platformName}");
      } else if (state == BluetoothConnectionState.connected) {
        print("Connected to ${device.platformName}");
      } else {
        print("Disconnected from ${device.platformName}");
      }
    });
  }

  // Discover services of a connected BLE device
  Future<List<BluetoothService>> discoverServices(BluetoothDevice device) async {
    return await device.discoverServices();
  }
}


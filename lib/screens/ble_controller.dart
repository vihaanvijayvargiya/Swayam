import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = [];

  final Map<Guid, List<int>> readValues = {};

  @override
  void onInit() {
    super.onInit();
    _startScan();
  }

  void _startScan() {
    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceToList(device);
      }
    });

    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceToList(result.device);
      }
    });

    flutterBlue.startScan();
  }

  void _addDeviceToList(BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      devicesList.add(device);
      update(); // Update the UI
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();

    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristic.value.listen((value) {
          _updateReadValue(characteristic.uuid, value);
        });
      }
    }
  }

  void _updateReadValue(Guid uuid, List<int> value) {
    readValues[uuid] = value;
    update(); // Notify listeners of the change
  }

  Future<void> writeData(BluetoothCharacteristic characteristic, String data) async {
    await characteristic.write(utf8.encode(data));
  }

  Future<void> toggleNotify(BluetoothCharacteristic characteristic) async {
    await characteristic.setNotifyValue(true);
  }

  void disconnectDevice(BluetoothDevice device) {
    device.disconnect();
  }

  Future<void> scanDevices() async {
    if (await Permission.bluetoothScan.request().isGranted) {
      if (await Permission.bluetoothConnect.request().isGranted) {
        flutterBlue.startScan(timeout: Duration(seconds: 15));
        flutterBlue.stopScan();
      }
    }
  }
}
import 'dart:typed_data'; // Add this import statement

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class PulseRateScreen extends StatefulWidget {
  final BluetoothDevice? device; // Make BluetoothDevice nullable

  PulseRateScreen({this.device});

  @override
  _PulseRateScreenState createState() => _PulseRateScreenState();
}

class _PulseRateScreenState extends State<PulseRateScreen> {
  BluetoothCharacteristic? characteristic;
  double heartRate = 0.0;
  double spo2 = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.device != null) {
      _discoverServices();
    }
  }

  void _discoverServices() async {
    if (widget.device == null) return;
    List<BluetoothService> services = await widget.device!.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == "0d45ee9d-5a43-46fa-8370-9651c48af2a0") {
          await characteristic.setNotifyValue(true);
          characteristic.value.listen((value) {
            setState(() {
              // Convert value to float for heart rate and SpO2
              heartRate = _convertToFloat(value.sublist(0, 4));
              spo2 = _convertToFloat(value.sublist(4, 8));
            });
          });
        }
      }
    }
  }

  double _convertToFloat(List<int> value) {
    var buffer = ByteData.view(Uint8List.fromList(value).buffer); // Use ByteData.view to create a view of the Uint8List's buffer
    return buffer.getFloat32(0, Endian.little);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pulse Rate'),
      ),
      body: Center(
        child: widget.device == null // Check if device is null
            ? Text('No device connected')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Heart Rate: $heartRate bpm'),
            Text('SpO2: $spo2 %'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class PulseRateScreen extends StatefulWidget {
  final BluetoothDevice device;

  PulseRateScreen({required this.device});

  @override
  _PulseRateScreenState createState() => _PulseRateScreenState();
}

class _PulseRateScreenState extends State<PulseRateScreen> {
  BluetoothCharacteristic? heartRateCharacteristic;
  BluetoothCharacteristic? spo2Characteristic;
  double heartRate = 0.0;
  double spo2 = 0.0;

  @override
  void initState() {
    super.initState();
    _discoverServices();
  }

  void _discoverServices() async {
    if (widget.device == null) return;
    List<BluetoothService> services = await widget.device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == "00002a37-0000-1000-8000-00805f9b34fb") {
          heartRateCharacteristic = characteristic;
          await heartRateCharacteristic!.setNotifyValue(true);
          heartRateCharacteristic!.value.listen((value) {
            setState(() {
              heartRate = value[0].toDouble();  // Example conversion, adjust as necessary
            });
          });
        }
        if (characteristic.uuid.toString() == "00002a5f-0000-1000-8000-00805f9b34fb") {
          spo2Characteristic = characteristic;
          await spo2Characteristic!.setNotifyValue(true);
          spo2Characteristic!.value.listen((value) {
            setState(() {
              spo2 = value[0].toDouble();  // Example conversion, adjust as necessary
            });
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pulse Rate'),
      ),
      body: Center(
        child: Column(
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

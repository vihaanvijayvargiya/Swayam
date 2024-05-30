import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ECGScreen extends StatefulWidget {
  final BluetoothDevice? device;

  ECGScreen({this.device});

  @override
  _ECGScreenState createState() => _ECGScreenState();
}

class _ECGScreenState extends State<ECGScreen> {
  BluetoothCharacteristic? characteristic;
  double ecgValue = 0.0;

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
        if (characteristic.uuid.toString() == "0d45ee9d-5a43-46fa-8370-9651c48af2a") {
          await characteristic.setNotifyValue(true);
          characteristic.value.listen((value) {
            setState(() {
              ecgValue = _convertToFloat(value);
            });
          });
        }
      }
    }
  }

  double _convertToFloat(List<int> value) {
    var buffer = ByteData.view(Uint8List.fromList(value).buffer);
    return buffer.getFloat32(0, Endian.little);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ECG Data'),
      ),
      body: Center(
        child: widget.device == null
            ? Text('No device connected')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('ECG Value: $ecgValue'),
          ],
        ),
      ),
    );
  }
}

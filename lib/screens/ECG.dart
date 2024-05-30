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
        backgroundColor: Colors.blue,
        title: Text(
          "ECG",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: widget.device == null
                      ? Text(
                    'N/A',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'ECG: $ecgValue',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'hola',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Electrocardiogram \n'
                  '\nECG measures the electrical activity of the heart to detect any abnormalities. It helps to diagnose various heart conditions, such as arrhythmias, heart attacks, and other cardiac issues, enabling timely and appropriate medical intervention.',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

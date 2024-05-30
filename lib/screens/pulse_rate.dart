import 'dart:typed_data'; 
import 'package:pretty_gauge/pretty_gauge.dart';
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
        backgroundColor: Colors.red,
        title: Text(
          "Heart Rate",
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
                  color: Color(0xFFFFCCCB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: widget.device == null
                      ? Text(
                    'N/A',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Heart Rate: $heartRate bpm',
                        style: TextStyle(
                          color: Colors.red,
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
                  color: Color(0xFFFFCCCB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'hola',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Color(0xFFFFCCCB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Heart rate in resting state usually varies between 60 and 100 \n'
                      '\nActive Heart Rate: Exercise process according to the heart rate interval can determine the body\'s movement state, select the appropriate heart rate interval to achieve better sporting effect.',
                  style: TextStyle(
                    color: Colors.red,
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

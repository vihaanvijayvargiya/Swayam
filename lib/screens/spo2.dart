import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:pretty_gauge/pretty_gauge.dart';

class SpO2Screen extends StatefulWidget {
  final BluetoothDevice? device;
  SpO2Screen({this.device});

  @override
  _SpO2ScreenState createState() => _SpO2ScreenState();
}

class _SpO2ScreenState extends State<SpO2Screen> {
  BluetoothCharacteristic? characteristic;
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
        backgroundColor: Colors.green,
        title: Text(
          "SpO2",
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
                  color: Color(0x9990EE90),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: widget.device == null
                      ? Text(
                    'N/A',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'SpO2: $spo2 %',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              PrettyGauge(
                gaugeSize: 300,
                minValue: 0,
                maxValue: 100, // SpO2 values typically range from 0 to 100%
                segments: [
                  GaugeSegment('Low', 85, Colors.red), // Below 85% is considered low and critical
                  GaugeSegment('Normal', 10, Colors.green), // 85% to 95% is considered normal
                  GaugeSegment('High', 5, Colors.blue), // Above 95% is considered high and optimal
                ],
                valueWidget: Text(
                  spo2.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 40),
                ),
                currentValue: spo2,
                needleColor: Colors.blue,
              ),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0x9990EE90),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Understanding Oxygen Saturation Data \n'
                      '\nOxygen Saturation is the percentage of oxygen-bound oxyhemoglobin in the blood that counts for the total amount of hemoglobin that can be combined that is the concentration of blood oxygen in the blood, which is an important physiological parameter of respiratory cycle\n'
                  '\n Normal arterial oxygen saturation of about 95-100%',
                  style: TextStyle(
                    color: Colors.green,
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

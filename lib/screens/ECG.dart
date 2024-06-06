import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fl_chart/fl_chart.dart';

class ECGScreen extends StatefulWidget {
  final BluetoothDevice? device;

  ECGScreen({this.device});

  @override
  _ECGScreenState createState() => _ECGScreenState();
}

class _ECGScreenState extends State<ECGScreen> {
  List<double> ecgValues = []; // List to store ECG values

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
            double newValue = _convertToFloat(value.sublist(0, 4));
            setState(() {
              ecgValues.add(newValue); // Add new ECG value to the list
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
                height: 200, // Adjust the height as needed
                child: ecgValues.isEmpty
                    ? Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                )
                    : LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: ecgValues.length.toDouble() - 1,
                    minY: ecgValues.reduce((a, b) => a < b ? a : b) - 10,
                    maxY: ecgValues.reduce((a, b) => a > b ? a : b) + 10,
                    titlesData: FlTitlesData(
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTitles: (value) {
                          if (value % 20 == 0) {
                            return value.toInt().toString();
                          }
                          return '';
                        },
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTitles: (value) {
                          return value.toInt().toString();
                        },
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 20,
                    ),
                    borderData: FlBorderData(
                      show: true,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          ecgValues.length,
                              (index) => FlSpot(index.toDouble(), ecgValues[index]),
                        ),
                        isCurved: true,
                        colors: [Colors.blue],
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: false,
                        ),
                        belowBarData: BarAreaData(
                          show: false,
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

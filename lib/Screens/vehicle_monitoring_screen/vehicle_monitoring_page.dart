import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../home_screen/homepage.dart';
import '../incident_history_screen/incident_history_page.dart';
import '../profile_screen/profile_page.dart';
import '../settings_screen/settings_page.dart';

class VehicleMonitoringPage extends StatefulWidget {
  final String sensorName;

  const VehicleMonitoringPage({Key? key, required this.sensorName})
      : super(key: key);

  @override
  _VehicleMonitoringPageState createState() => _VehicleMonitoringPageState();
}

class _VehicleMonitoringPageState extends State<VehicleMonitoringPage> {
  String temperature = "Fetching Data...";
  String motion = "Fetching Data...";
  bool isLoading = true;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    fetchSensorData();
  }

  Future<void> fetchSensorData() async {
    setState(() {
      isLoading = true;
    });

    final String url =
        'https://api.thingspeak.com/channels/2554215/feeds.json?api_key=GQXZ7HQWUIPKL9I8&results=1';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final feeds = decodedData['feeds'];

        if (feeds.isNotEmpty) {
          setState(() {
            temperature = feeds[0]['field1'] ?? 'N/A';
            motion = feeds[0]['field2'] ?? 'N/A';
            isLoading = false;
          });
        } else {
          setState(() {
            temperature = 'No data available';
            motion = 'No data available';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          temperature = 'Error fetching data';
          motion = 'Error fetching data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        temperature = 'Error: $e';
        motion = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          break;
        case 1:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(currentUserId: '')));
          break;
        case 2:
          // Stay on the current page
          break;
        case 3:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingPage(currentUserId: '')));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Monitoring ${widget.sensorName}'),
        backgroundColor: Colors.purple[200],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLoading)
                Center(
                    child: SpinKitWave(color: Colors.purple[300], size: 50.0))
              else
                Column(
                  children: [
                    // Temperature Gauge
                    Column(
                      children: [
                        Text(
                          'Temperature Gauge',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 300,
                          height: 300,
                          child: TemperatureGauge(temperature: temperature),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    // Motion Indicator
                    Column(
                      children: [
                        Text(
                          'Motion Indicator',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 300,
                          height: 300,
                          child: MotionIndicator(motion: motion),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    // Sensor Tiles for Temperature and Motion Status
                    SensorTile(
                      title: 'Temperature',
                      value: temperature,
                      description:
                          'Monitoring the temperature to prevent heat-related issues.',
                    ),
                    SizedBox(height: 20),
                    SensorTile(
                      title: 'Motion Status',
                      value: motion == '1' ? 'Motion Detected' : 'No Motion',
                      description:
                          'Detects motion to ensure child safety in the vehicle.',
                    ),
                    SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: fetchSensorData,
                      icon: Icon(Icons.refresh),
                      label: Text('Refresh Data'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purple[300],
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IncidentHistoryPage()),
                        );
                      },
                      icon: Icon(Icons.history),
                      label: Text('History Log'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purple[300],
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SensorTile extends StatelessWidget {
  final String title;
  final String value;
  final String description;

  const SensorTile({
    Key? key,
    required this.title,
    required this.value,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            SizedBox(height: 8),
            Text(
              'Value: $value',
              style: TextStyle(fontSize: 20, color: Colors.purple[600]),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.purple[800]),
            ),
          ],
        ),
      ),
    );
  }
}

class TemperatureGauge extends StatelessWidget {
  final String temperature;

  const TemperatureGauge({Key? key, required this.temperature})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double tempValue = double.tryParse(temperature) ?? 0;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: -10,
            maximum: 45,
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: -10,
                endValue: 15,
                color: Colors.yellow[200],
                label: 'Cold',
              ),
              GaugeRange(
                startValue: 15,
                endValue: 38,
                color: Colors.green[200],
                label: 'Normal',
              ),
              GaugeRange(
                startValue: 38,
                endValue: 45,
                color: Colors.red[200],
                label: 'Hot',
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(value: tempValue),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Container(
                  child: Text(
                    '$temperature°C',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
                angle: 90,
                positionFactor: 0.5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MotionIndicator extends StatelessWidget {
  final String motion;

  const MotionIndicator({Key? key, required this.motion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMotionDetected = motion == '1';

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          isMotionDetected ? 'Motion Detected' : 'No Motion',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isMotionDetected ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }
}

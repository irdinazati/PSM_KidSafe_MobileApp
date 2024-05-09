import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class VehicleMonitoringPage extends StatefulWidget {
  final String sensorName;

  const VehicleMonitoringPage({Key? key, required this.sensorName}) : super(key: key);

  @override
  _VehicleMonitoringPageState createState() => _VehicleMonitoringPageState();
}

class _VehicleMonitoringPageState extends State<VehicleMonitoringPage> {
  String sensorValue = "Fetching Data..."; // Default sensor value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Monitoring: ${widget.sensorName}'),
        backgroundColor: Colors.purple.shade200, // Set app bar background color to purple
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sensor Name: ${widget.sensorName}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Sensor Value: $sensorValue',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Simulate fetching sensor data (Replace with actual data fetching mechanism)
    fetchSensorData();
  }

  void fetchSensorData() {
    // Simulating fetching sensor data after a delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        // Update sensor value
        sensorValue = "25°C"; // Example sensor value
      });
    });
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp3/Screens/home_screen/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../profile_screen/profile_page.dart';
import '../settings_screen/settings_page.dart';

class VehicleMonitoringPage extends StatefulWidget {
  final String sensorName;

  const VehicleMonitoringPage({Key? key, required this.sensorName}) : super(key: key);

  @override
  _VehicleMonitoringPageState createState() => _VehicleMonitoringPageState();
}

class _VehicleMonitoringPageState extends State<VehicleMonitoringPage> {
  String temperature = "Fetching Data..."; // Default sensor value
  String motion = "Fetching Data..."; // Default sensor value
  bool isLoading = true;
  int _selectedIndex = 2; // Index for the BottomNavigationBar

  @override
  void initState() {
    super.initState();
    // Fetch sensor data initially
    fetchSensorData();
  }

  Future<void> fetchSensorData() async {
    setState(() {
      isLoading = true;
    });

    final String url =
        'https://api.thingspeak.com/channels/2554215/feeds.json?api_key=GQXZ7HQWUIPKL9I8&results=1'; // Adjust the URL as needed

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
        // Handle error
        setState(() {
          temperature = 'Error fetching data';
          motion = 'Error fetching data';
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle error
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
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage(currentUserId: '')),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VehicleMonitoringPage(sensorName: widget.sensorName)),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingPage(currentUserId: '')),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Monitoring ${widget.sensorName}'),
        backgroundColor: Colors.purple[100], // Set app bar background color to purple[200]
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()), // Pass childId here
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sensors, size: 100, color: Colors.purple[300]),
                SizedBox(height: 20),
                Text(
                  'Sensor Name: ${widget.sensorName}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
                ),
                SizedBox(height: 20),
                isLoading
                    ? SpinKitWave(color: Colors.purple[300], size: 50.0)
                    : Column(
                        children: [
                          SensorTile(
                            title: 'Temperature Monitoring',
                            value: temperature,
                            description: 'The temperature inside the car is constantly being tracked by the KidSafe app. In order to assist avoid heat-related illnesses or fatalities, carers get notifications when the temperature rises over acceptable limits.',
                          ),
                          TemperatureDiagram(temperature: temperature),
                          SensorTile(
                            title: 'Motion Monitoring',
                            value: motion,
                            description: 'This feature utilises motion sensors to monitor the child\'s movements in the car seat, ensuring their presence and safety. Carers are alerted if there are unexpected movements that could indicate a potential issue.',
                          ),
                          MotionDiagram(motion: motion),
                        ],
                      ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: fetchSensorData,
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh Data'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple[300],
                    onPrimary: Colors.white,
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.purple[200], // Set background color to purple
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_crash_rounded),
            label: 'Vehicle Monitoring',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white, // Set selected item color to white for better contrast
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensure the type is fixed to display all items equally
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
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
            SizedBox(height: 8),
            Text(
              'Value: $value',
              style: TextStyle(fontSize: 18, color: Colors.purple[600]),
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

class TemperatureDiagram extends StatelessWidget {
  final String temperature;

  const TemperatureDiagram({Key? key, required this.temperature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double tempValue = double.tryParse(temperature) ?? 0;
    String indicatorText;
    Color bgColor;

    if (tempValue <= 20) {
      bgColor = Colors.blue;
      indicatorText = 'Low';
    } else if (tempValue <= 30) {
      bgColor = Colors.green;
      indicatorText = 'Okay';
    } else if (tempValue <= 40) {
      bgColor = Colors.yellow;
      indicatorText = 'High';
    } else {
      bgColor = Colors.red;
      indicatorText = 'High';
    }

    return Container(
      width: 200,
      height: 30,
      color: bgColor,
      child: Center(
        child: Text(
          indicatorText,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

class MotionDiagram extends StatelessWidget {
  final String motion;

  const MotionDiagram({Key? key, required this.motion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int motionValue = int.tryParse(motion) ?? 0;
    String indicatorText = motionValue == 0 ? 'Low' : 'High';
    Color bgColor = motionValue == 0 ? Colors.green : Colors.red;

    return Container(
      width: 200,
      height: 30,
      color: bgColor,
      child: Center(
        child: Text(
          indicatorText,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

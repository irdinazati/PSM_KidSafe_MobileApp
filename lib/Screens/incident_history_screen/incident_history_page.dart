import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp3/Screens/home_screen/homepage.dart';
import 'package:fyp3/Screens/vehicle_monitoring_screen/vehicle_monitoring_page.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

import '../profile_screen/profile_page.dart';
import '../settings_screen/settings_page.dart';

class IncidentHistoryPage extends StatefulWidget {
  @override
  _IncidentHistoryPageState createState() => _IncidentHistoryPageState();
}

class _IncidentHistoryPageState extends State<IncidentHistoryPage> {
  List<charts.Series<dynamic, DateTime>> seriesList1 = [];
  List<charts.Series<dynamic, DateTime>> seriesList2 = [];
  List<charts.Series<dynamic, DateTime>> seriesList3 = [];

  void _onItemTapped(int index) {
    setState(() {
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
            MaterialPageRoute(builder: (context) => VehicleMonitoringPage(sensorName: '')),
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
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final String url =
        'https://api.thingspeak.com/channels/2554215/feeds.json?api_key=GQXZ7HQWUIPKL9I8&results=10';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final feeds = decodedData['feeds'];

        // Function to convert timestamp to DateTime object
        DateTime timestampToDate(String timestamp) =>
            DateTime.parse(timestamp);

        setState(() {
          seriesList1 = [
            charts.Series<dynamic, DateTime>(
              id: 'Field 1',
              colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.purpleAccent),
              domainFn: (dynamic feed, _) => timestampToDate(feed['created_at']),
              measureFn: (dynamic feed, _) => double.parse(feed['field1'] ?? '0'),
              data: feeds,
            ),
          ];

          seriesList2 = [
            charts.Series<dynamic, DateTime>(
              id: 'Field 2',
              colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.purpleAccent),
              domainFn: (dynamic feed, _) => timestampToDate(feed['created_at']),
              measureFn: (dynamic feed, _) => double.parse(feed['field2'] ?? '0'),
              data: feeds,
            ),
          ];

          // seriesList3 = [
          //   charts.Series<dynamic, DateTime>(
          //     id: 'Field 3',
          //     colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.purpleAccent),
          //     domainFn: (dynamic feed, _) => timestampToDate(feed['created_at']),
          //     measureFn: (dynamic feed, _) => double.parse(feed['field3'] ?? '0'),
          //     data: feeds,
          //   ),
          // ];
        });
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Log'),
        backgroundColor: Colors.purple[100],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildChartContainer('Temperature Graph', seriesList1, 'Temperature is measured in Celsius. Higher values indicate warmer temperatures. This graph helps you visualize temperature changes over time, providing valuable insights for parents. \n\nTemperature Monitoring: As a parent, you can track the temperature inside the car using the KidSafe app. This feature ensures you stay informed about the temperature conditions inside the car, helping you take necessary actions to ensure comfor and safety of your child.'),
            SizedBox(height: 20),
            // buildChartContainer('Sound Level Graph', seriesList2),
            SizedBox(height: 20),
            buildChartContainer('Motion Graph', seriesList2, 'The motion graph represents the level of movement detected inside the vehicle. Higher values suggest increased motion activity, which can indicate events such as vehicle movement or physical activity of your child. \n\nMotion Monitoring: As a parent using the KidSafe app, you can track movement of your child in the car seat. This feature ensures you are aware with activity level of your child during the journey, helping you ensure their comfort and safety. This graph provides valuable insights to keep your child secure while traveling.'),
          ],
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
            icon: Icon(Icons.car_crash_outlined),
            label: 'Vehicle Monitoring',
          ),
        ],
        selectedItemColor: Colors.white, // Set selected item color to white for better contrast
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensure the type is fixed to display all items equally
      ),
    );
  }

  Widget buildChartContainer(String title, List<charts.Series<dynamic, DateTime>> seriesList, String explanation) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: charts.TimeSeriesChart(
                seriesList,
                animate: true,
              ),
            ),
            SizedBox(height: 10),
            Text(
              explanation,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp3/Screens/community_screen/community_page.dart';
import 'package:fyp3/Screens/educational_resources_screen/educational_homepage.dart';
import 'package:fyp3/Screens/feedback_screen/feedback_page.dart';
import 'package:fyp3/Screens/profile_screen/profile_page.dart';
import 'package:fyp3/Screens/settings_screen/settings_page.dart';
import 'package:fyp3/Screens/vehicle_monitoring_screen/vehicle_monitoring_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../child_screen/child_homepage.dart';

class HomePage extends StatefulWidget {
  final String? currentUserId;

  const HomePage({Key? key, this.currentUserId}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _motionStatus = 0; // 0 = Green (No Motion), 1 = Red (Motion Detected)
  double _temperature = 0.0; // Initialize with a default temperature
  Timer? _timer; // Timer instance for the message sending duration
  bool _isLoading = true; // Add this to your state

  @override
  void initState() {
    super.initState();
    fetchThingSpeakData(); // Fetch data when the widget is initialized
  }



  Future<void> fetchThingSpeakData() async {
    final String url =
        'https://api.thingspeak.com/channels/2554215/feeds.json?api_key=GQXZ7HQWUIPKL9I8&results=1';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _motionStatus =
              int.parse(data['feeds'][0]['field2']); // Adjust as needed
          _temperature =
              double.parse(data['feeds'][0]['field1']); // Adjust as needed
          _isLoading = false; // Data loaded successfully
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
      // Handle error by showing a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage(currentUserId: widget.currentUserId)),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(currentUserId: '')),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => VehicleMonitoringPage(sensorName: '')),
          );
          break;
      }
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildAppBar(context),
              _buildIndicators(),
              _buildImage(),
              _buildDashboard(),
              const SizedBox(height: 20),
            ],
          ),
    bottomNavigationBar: _buildBottomNavigationBar(),
  );
}


  Widget _buildImage() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 20.0), // Add vertical padding
      child: Image.asset(
        'assets/welcome.png', // Image path
        height: 100, // Adjust height as needed
        width: 100, // Adjust width as needed
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple[200],
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hello, Parent!',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SettingPage(currentUserId: widget.currentUserId)),
                    );
                  },
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Icon(Icons.settings, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 20.0, horizontal: 30.0), // Add horizontal padding
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.purple[100],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _motionIndicator()),
                const SizedBox(width: 20), // Space between indicators
                Expanded(child: _temperatureIndicator()),
              ],
            ),
            const SizedBox(height: 20), // Space after indicators
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 5),
                    color: Theme.of(context).primaryColor.withOpacity(.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Motion Indicators:',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4), // Space before color display
                  Text(
                    '🟢 Green: No motion\n🔴 Red: Motion detected',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8), // Space after first indicator text
                  Text(
                    'Temperature Indicators:',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4), // Space before temperature display
                  Text(
                    '🔴 Red: Hot\n🟡 Yellow: Cold\n🟢 Green: Normal',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(200),
        ),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 40,
        mainAxisSpacing: 30,
        children: [
          _itemDashboard('Profile', CupertinoIcons.person_crop_circle,
              Colors.orange, ProfilePage(currentUserId: '')),
          _itemDashboard('Child Profile', CupertinoIcons.person_crop_circle,
              Colors.grey, ChildInfoPage(currentUserId: widget.currentUserId)),
          _itemDashboard('Vehicle Monitoring', CupertinoIcons.car, Colors.green,
              VehicleMonitoringPage(sensorName: '')),
          _itemDashboard('Educational Resources', CupertinoIcons.book,
              Colors.brown, EducationalHomePage()),
          _itemDashboard('Feedback', CupertinoIcons.pencil, Colors.yellow,
              FeedbackPage(currentUserId: widget.currentUserId)),
          _itemDashboard(
              'Community', CupertinoIcons.book, Colors.pink, CommunityScreen()),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.purple[200],
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
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }

  Widget _itemDashboard(
      String title, IconData iconData, Color background, Widget nextPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _motionIndicator() {
    Color indicatorColor = _motionStatus == 0 ? Colors.green : Colors.red;

    return Container(
      width: 170, // Set a fixed width
      height: 210, // Set a fixed height
      decoration: BoxDecoration(
        color: indicatorColor, // Use status color as background
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Theme.of(context).primaryColor.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 8.0), // Add margin for gap
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_run, color: Colors.black),
          ),
          const SizedBox(height: 10),
          Text(
            'Motion Status:',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            _motionStatus == 0 ? 'No Motion' : 'Motion Detected',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8), // Space before color display
        ],
      ),
    );
  }

  Widget _temperatureIndicator() {
  Color indicatorColor;
  if (_temperature > 40) {
    indicatorColor = Colors.red; // Hot
  } else if (_temperature < 15) {
    indicatorColor = Colors.yellow; // Cold
  } else {
    indicatorColor = Colors.green; // Normal
  }

  return Container(
    width: 150, // Set a fixed width
    height: 210, // Set a fixed height
    decoration: BoxDecoration(
      color: indicatorColor, // Use status color as background
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 5),
          color: Theme.of(context).primaryColor.withOpacity(.2),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.symmetric(horizontal: 8.0), // Add margin for gap
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.thermostat, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          'Temp: ${_temperature.toStringAsFixed(1)} °C',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible, // Ensure text is visible
        ),
        const SizedBox(height: 4),
        Text(
          _temperature > 40
              ? 'Hot'
              : (_temperature < 15 ? 'Cold' : 'Normal'),
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}

}
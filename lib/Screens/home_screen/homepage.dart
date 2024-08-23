import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../../Controller/OneSignalController.dart';
import '../child_screen/child_homepage.dart';
import '../notification_screen/controllers.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchThingSpeakData(); // Fetch data when the widget is initialized
    print("UID: ${widget.currentUserId!}");
    initiateSensorsAndNotifications(widget.currentUserId!); // Start sensor checks
  }
  
Future<void> fetchThingSpeakData() async {
  final String url =
      'https://api.thingspeak.com/channels/2554215/feeds.json?api_key=GQXZ7HQWUIPKL9I8&results=1';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final int motionStatus =
          int.parse(data['feeds'][0]['field2']); // Adjust as needed
      final double temperature =
          double.parse(data['feeds'][0]['field1']); // Adjust as needed

      // Save to Firestore
      await _firestore.collection('sensor_data').add({
        'timestamp': Timestamp.now(),
        'motion_status': motionStatus,
        'temperature': temperature,
      });

      setState(() {
        _motionStatus = motionStatus;
        _temperature = temperature;
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

  // void _onItemTapped(int index) {
  //   if (index != _selectedIndex) {
  //     setState(() {
  //       _selectedIndex = index;
  //     });
  //     switch (index) {
  //       case 0:
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) =>
  //                   HomePage(currentUserId: widget.currentUserId)),
  //         );
  //         break;
  //       case 1:
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => ProfilePage(currentUserId: '')),
  //         );
  //         break;
  //       case 2:
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => VehicleMonitoringPage(sensorName: '')),
  //         );
  //         break;
  //     }
  //   }
  // }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildAppBar(context),
              const SizedBox(height: 30),
              _buildConclusion(),
              _buildIndicators(),
              _buildImage(),
              _buildDashboard(),
              const SizedBox(height: 20),
            ],
          ),
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

  Widget _buildConclusion() {
  String conclusionMessage;
  IconData alertIcon;

  if (_motionStatus == 0) {
    conclusionMessage = 'The kid is not in the car.';
    alertIcon = Icons.check_circle; // Check mark for no issue
  } else {
    conclusionMessage = 'The kid is in the car!';
    alertIcon = Icons.warning; // Warning icon for alert
  }

  return Container(
    padding: const EdgeInsets.all(15).copyWith(top: 30), // Add top padding
    decoration: BoxDecoration(
      color: Colors.purple[300], // Purple color for the box
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 5),
          color: Colors.purple.withOpacity(.2), // Light purple shadow
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    margin: const EdgeInsets.symmetric(horizontal: 30), // Align with other widgets
    child: Padding(
      padding: const EdgeInsets.only(top: 20.0), // Add top padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the content
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white, // White background for the icon
              shape: BoxShape.circle,
            ),
            child: Icon(
              alertIcon,
              color: Colors.purple[100],
              size: 40,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'ALERT:',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), // White text
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            conclusionMessage,
            style: TextStyle(
                color: Colors.white, fontSize: 16), // White text
            textAlign: TextAlign.center,
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
          _itemDashboard('Community', CupertinoIcons.book, 
              Color.fromARGB(255, 33, 30, 233), CommunityScreen()),
              // _itemDashboard('Report', CupertinoIcons.book, 
              //  Colors.pink, ReportPage()),
        ],
      ),
    );
  }

// Widget _buildBottomNavigationBar(BuildContext context) {
//     return ConvexAppBar.badge(
//       {0: '99+', 1: Icons.assistant_photo, 2: Colors.redAccent},
//       items: [
//         TabItem(icon: Icons.home, title: 'Home'),
//         TabItem(icon: Icons.person, title: 'Profile'),
//         TabItem(icon: Icons.car_crash_outlined, title: 'Vehicle Monitoring'),
//       ],
//       onTap: (int i) {
//         switch (i) {
//           case 0:
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => HomePage()),
//             );
//             break;
//           case 1:
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ProfilePage(currentUserId: '')),
//             );
//             break;
//           case 2:
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => VehicleMonitoringPage(sensorName: '')),
//             );
//             break;
//         }
//       },
//     );
//   }
  

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
  if (_temperature > 38) {
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
          _temperature > 38
              ? 'Hot'
              : (_temperature < 15 ? 'Cold' : 'Normal'),
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}

Future<void> initiateSensorsAndNotifications(String userid) async {
  ThingSpeakController thingSpeakController = ThingSpeakController();
  TelegramController telegramController = TelegramController();

  double? lastTemperature;
  double? lastMotion;

  // declare object for OneSignal notification
  OneSignalController onesignal = new OneSignalController();
  String title = "";
  String message = "";
  List<String> targetUser = [];

  Timer.periodic(Duration(seconds: 5), (Timer timer) async {
    // Read sensor data from ThingSpeak
    Map<String, double> sensorData = await thingSpeakController.readSensorData();

    if (sensorData.isNotEmpty) {
      double temperature = sensorData['temperature']!;
      double motion = sensorData['motion']!;

      // Define the thresholds
      double temperatureThreshold = 38.0;
      double motionThreshold = 1.0;

      // Check if the temperature exceeds the threshold and if it has changed
      if (temperature > temperatureThreshold && temperature != lastTemperature) {
        lastTemperature = temperature;
        // setup notification config for OneSignal
        title = "TEMPERATURE ALERT";
        message = "🚨Temperature has exceeded the threshold";
        targetUser.add(userid);

        onesignal.SendNotification(title, message, targetUser);
        
        await sendTemperatureAlert(telegramController, temperature);
      }

      // Check if motion is detected and if it has changed
      if (motion >= motionThreshold && motion != lastMotion) {
        lastMotion = motion;
        await sendMotionAlert(telegramController);

         // setup notification config for OneSignal
        title = "MOTION ALERT";
        message = "🚨Motion has been detected!";
        targetUser.add(userid);

        onesignal.SendNotification(title, message, targetUser);
      }

      print("Temperature: $temperature, Motion: $motion");
    } else {
      print("Failed to retrieve sensor data.");
      timer.cancel(); // Stop the timer if data retrieval fails
    }
  });
}

Future<void> sendTemperatureAlert(TelegramController telegramController, double temperature) async {
  await telegramController.sendTelegramNotification(
    "🚨 Temperature Alert: Temperature has exceeded the threshold: $temperature°C"
  );

  // Wait for 3 minutes before sending the reminder
  await Future.delayed(Duration(minutes: 3));
  
  await telegramController.sendTelegramNotification(
    "🔄 Reminder: High temperature still detected: $temperature°C"
  );
}

Future<void> sendMotionAlert(TelegramController telegramController) async {
  await telegramController.sendTelegramNotification(
    "🚨 Motion Alert: Motion has been detected!"
  );

  // Wait for 3 minutes before sending the reminder
  await Future.delayed(Duration(minutes: 3));
  
  await telegramController.sendTelegramNotification(
    "🔄 Reminder: Motion has been detected!"
  );
}

}
import 'package:flutter/material.dart';
import 'package:fyp3/Screens/educational_resources_screen/parenting_page.dart';
import 'package:fyp3/Screens/home_screen/homepage.dart';
import 'package:fyp3/Screens/vehicle_monitoring_screen/vehicle_monitoring_page.dart';
import '../profile_screen/profile_page.dart';
import '../settings_screen/settings_page.dart';
import 'educational_resources_page.dart';

class EducationalHomePage extends StatefulWidget {
  const EducationalHomePage({Key? key}) : super(key: key);

  @override
  State<EducationalHomePage> createState() => _EducationalHomePageState();
}

class _EducationalHomePageState extends State<EducationalHomePage> {

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
            MaterialPageRoute(builder: (context) => VehicleMonitoringPage(sensorName: '',)),
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
        title: Text('Educational Resources'),
        backgroundColor: Colors.purple[100],
          leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black), // Use a color that fits your design
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Types of Resources',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 180,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EducationalResourcesPage()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/youtube.png',
                            height: 100,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'YouTube',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[100],
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    height: 180,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ParentingPage()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/family.png',
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tips for Parenting',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[100],
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Parenting Tips:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 50),
                  Image.asset(
                    'assets/1.png',
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 50),
                  Image.asset(
                    'assets/2.png',
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 50),
                  Image.asset(
                    'assets/3.png',
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 50),
                  Image.asset(
                    'assets/4.png',
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 50),
                  Image.asset(
                    'assets/5.png',
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 50),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: ConvexAppBar.badge(
      //   {0: '99+', 1: Icons.assistant_photo, 2: Colors.redAccent},
      //   items: [
      //     TabItem(icon: Icons.home, title: 'Home'),
      //     TabItem(icon: Icons.person, title: 'Profile'),
      //     TabItem(icon: Icons.car_crash_outlined, title: 'Vehicle Monitoring'),
      //   ],
      //   onTap: (int i) {
      //     switch (i) {
      //       case 0:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => HomePage()),
      //         );
      //         break;
      //       case 1:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => ProfilePage(currentUserId: '')),
      //         );
      //         break;
      //       case 2:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => VehicleMonitoringPage(sensorName: '',)),
      //         );
      //         break;
      //     }
      //   },
      // ),
    );
  }
}


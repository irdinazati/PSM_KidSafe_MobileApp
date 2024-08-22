import 'package:flutter/material.dart';
import 'package:fyp3/Screens/educational_resources_screen/educational_homepage.dart';
import 'package:fyp3/Screens/vehicle_monitoring_screen/vehicle_monitoring_page.dart';
import '../home_screen/homepage.dart';
import '../profile_screen/profile_page.dart';
import '../settings_screen/settings_page.dart';

class ParentingPage extends StatefulWidget {
  const ParentingPage({Key? key}) : super(key: key);

  @override
  State<ParentingPage> createState() => _ParentingPageState();
}

class _ParentingPageState extends State<ParentingPage> {

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
        title: Text('Parenting Tips'),
        backgroundColor: Colors.purple[100],
          leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black), // Use a color that fits your design
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Container(
        color: Colors.purple[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTipCard(
                        title: 'Establish Routine',
                        description:
                        'Set up a daily routine for your child to provide structure and predictability.',
                      ),
                      SizedBox(height: 16),
                      _buildTipCard(
                        title: 'Communicate',
                        description:
                        'Open communication helps build trust and strengthens the parent-child relationship.',
                      ),
                      SizedBox(height: 16),
                      _buildTipCard(
                        title: 'Lead by Example',
                        description:
                        'Children learn by observing, so be a positive role model for them.',
                      ),
                      SizedBox(height: 16),
                      _buildTipCard(
                        title: 'Show Affection',
                        description:
                        'Express love and affection regularly to foster emotional well-being.',
                      ),
                      SizedBox(height: 16),
                      _buildTipCard(
                        title: 'Set Limits',
                        description:
                        'Establish clear rules and boundaries to teach responsibility and respect.',
                      ),
                      SizedBox(height: 16),
                      _buildTipCard(
                        title: 'Be Patient',
                        description:
                        'Parenting can be challenging, so practice patience and understanding.',
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  Widget _buildTipCard(
      {required String title, required String description}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}


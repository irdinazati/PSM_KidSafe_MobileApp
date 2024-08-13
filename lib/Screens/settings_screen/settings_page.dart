import 'package:flutter/material.dart';
import 'package:fyp3/Screens/login_screen/login_page.dart';
import 'package:fyp3/Screens/settings_screen/system_info.dart';
import 'package:fyp3/Screens/vehicle_monitoring_screen/vehicle_monitoring_page.dart';
import '../../services/databaseServices.dart';
import '../home_screen/homepage.dart';
import '../profile_screen/profile_page.dart';

class SettingPage extends StatefulWidget {
  final String? currentUserId;

  const SettingPage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int _selectedIndex = 0; // Default to the Settings tab

  Future<void> handleDeactivateAccount(BuildContext context) async {
  bool? confirmDeactivation = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm Deactivation"),
        content: Text("Are you sure you want to deactivate your account?"),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(false); // User canceled
            },
          ),
          TextButton(
            child: Text("Confirm"),
            onPressed: () async {
              Navigator.of(context).pop(true); // User confirmed
              if (widget.currentUserId != null && widget.currentUserId!.isNotEmpty) {
                // Perform account deactivation
                DatabaseServices databaseServices = DatabaseServices();
                await databaseServices.softDeleteUser(widget.currentUserId);
                // Redirect to login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } else {
                print('Error: currentUserId is null or empty');
              }
            },
          ),
        ],
      );
    },
  );
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
            MaterialPageRoute(builder: (context) => HomePage()),
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
                builder: (context) => VehicleMonitoringPage(
                      sensorName: '',
                    )),
          );
          break;
        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings'),
        backgroundColor: Colors.purple[100], // Set app bar color to green
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage()), // Pass childId here
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the content vertically
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SystemInfo(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'About Us',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100], // Set button color to green
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                handleDeactivateAccount(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Deactivate Account',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100],
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors
            .white, // Set selected item color to white for better contrast
        onTap: _onItemTapped,
        type: BottomNavigationBarType
            .fixed, // Ensure the type is fixed to display all items equally
      ),
    );
  }
}

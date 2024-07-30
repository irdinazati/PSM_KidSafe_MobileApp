import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fyp3/Screens/vehicle_monitoring_screen/vehicle_monitoring_page.dart';
import '../home_screen/homepage.dart';
import '../profile_screen/profile_page.dart';
import '../settings_screen/settings_page.dart';
import 'add_child.dart';
import 'child_profile.dart';

class ChildInfoPage extends StatefulWidget {
  final String? currentUserId;

  const ChildInfoPage({Key? key, this.currentUserId}) : super(key: key);

  @override
  _ChildInfoPageState createState() => _ChildInfoPageState();
}

class _ChildInfoPageState extends State<ChildInfoPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        elevation: 0,
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
        title: Text("Child Information"),
      ),
      body: Center( // Center widget added here
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            children: [
              SizedBox(height: 40),
              FadeInUp(
                duration: Duration(milliseconds: 1000),
                child: Image.asset(
                  'assets/child.png',
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30),
              _buildMenuItem(
                title: "Display Child Profile",
                icon: Icons.child_care,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayChildProfile(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                title: "Add Child Profile",
                icon: Icons.add,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddChildProfile(),
                    ),
                  );
                },
              ),
              _buildDivider(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey,
      height: 15,
      thickness: 1,
      indent: 15,
      endIndent: 15,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(currentUserId: widget.currentUserId)),
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
            MaterialPageRoute(builder: (context) => SettingPage(currentUserId: widget.currentUserId)),
          );
          break;
      }
    });
  }
}

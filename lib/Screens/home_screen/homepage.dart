import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../child_screen/child_homepage.dart';
import '../educational_resources_screen/educational_homepage.dart';
import '../feedback_screen/feedback_page.dart';
import '../incident_history_screen/incident_history_page.dart';
import '../profile_screen/profile_page.dart';
import '../settings_screen/settings_page.dart';
import '../vehicle_monitoring_screen/vehicle_monitoring_page.dart';

class HomePage extends StatefulWidget {
  final String? currentUserId;

  const HomePage({Key? key, this.currentUserId}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage(currentUserId: widget.currentUserId)),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(currentUserId: widget.currentUserId!)),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const VehicleMonitoringPage(
                      sensorName: '',
                    )),
          );
          break;
       
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.purple[200],
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
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
                            Icon(Icons.settings),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: Colors.purple[200],
            child: Container(
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
                  itemDashboard('Profile', CupertinoIcons.person_crop_circle,
                      Colors.orange, const ProfilePage(currentUserId: '')),
                  itemDashboard(
                      'Child Profile',
                      CupertinoIcons.person_crop_circle,
                      Colors.grey,
                      ChildInfoPage(currentUserId: widget.currentUserId)),
                  itemDashboard(
                      'Vehicle Monitoring',
                      CupertinoIcons.car,
                      Colors.green,
                      const VehicleMonitoringPage(sensorName: '')),
                  itemDashboard('Educational Resources', CupertinoIcons.book,
                      Colors.brown, const EducationalHomePage()),
                  itemDashboard(
                      'Feedback',
                      CupertinoIcons.pencil,
                      Colors.yellow,
                      FeedbackPage(currentUserId: widget.currentUserId)),
                  itemDashboard('History Log', CupertinoIcons.time, Colors.pink,
                      IncidentHistoryPage()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget itemDashboard(
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
                  blurRadius: 5)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: Colors.white)),
            const SizedBox(height: 8),
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp3/Screens/login_screen/login_page.dart';
import 'package:get/get.dart';

import '../../widget/profile_menu.dart';
import '../child_screen/update_child_profile.dart';
import '../home_screen/homepage.dart';
import '../profile_screen/profile_page.dart';
import '../settings_screen/settings_page.dart';
import 'add_child.dart';
import 'child_profile.dart';

class ChildInfoPage extends StatefulWidget {
  @override
  _ChildInfoPageState createState() => _ChildInfoPageState();
}

class _ChildInfoPageState extends State<ChildInfoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home'), // Replace with your home widget
    Text('Notifications'), // Replace with your notifications widget
    Text('Settings'), // Replace with your settings widget
  ];

  void _onItemTapped(int index) {
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
              MaterialPageRoute(builder: (context) => ChildInfoPage()),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50], // Set the background color
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[100],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
        title: Text("Child Information"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FadeInUp(
              duration: Duration(milliseconds: 1000),
              child: Image.asset(
                'assets/child.png',
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            ProfileMenuWidget(
              title: "Display Child Profile",
              icon: Icons.child_care,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayChildProfile(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Divider(
              color: Colors.grey,
              height: 15,
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
            SizedBox(height: 20),
            ProfileMenuWidget(
              title: "Add Child Profile",
              icon: Icons.add,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddChildProfile(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Divider(
              color: Colors.grey,
              height: 15,
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
            SizedBox(height: 20),
            ProfileMenuWidget(
              title: "Update Child Profile",
              icon: Icons.edit,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateChildProfile(childId: ''),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care_rounded),
            label: 'Add Child',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

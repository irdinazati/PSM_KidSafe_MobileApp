import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp3/Screens/login_screen/login_page.dart';
import 'package:fyp3/Screens/vehicle_monitoring_screen/vehicle_monitoring_page.dart';
import '../Google Login.dart';

import '../../widget/profile_menu.dart';
import '../home_screen/homepage.dart';
import '../settings_screen/settings_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final String currentUserId;
  const ProfilePage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 1;

  Future<Map<String, dynamic>> _fetchParentData() async {
    User? parent = _auth.currentUser;

    try {
      if (parent != null) {
        DocumentSnapshot documentSnapshot =
        await _firestore.collection('parents').doc(parent.uid).get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> parentData =
          documentSnapshot.data() as Map<String, dynamic>;
          parentData['parentProfilePicture'] =
              parentData['parentProfilePicture'] ?? '';
          return parentData;
        } else {
          print('Document does not exist');
        }
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }

    return {};
  }

  // Function to show logout confirmation dialog
  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.purple[200], // Set text color to purple
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _logout(); // Call the logout function if confirmed
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage())
                );
                // Close the dialog
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.purple[200], // Set text color to purple
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to perform logout
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleLogin.logout();
      // Redirect to the login page after logout
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (error) {
      print('Error during logout: $error');
    }
  }

  // Implement this function for bottom navigation
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
            MaterialPageRoute(builder: (context) => ProfilePage(currentUserId: '',)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50], // Set the background color
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: Text("Parent User Profile"),
        centerTitle: true,
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
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _fetchParentData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                String parentFullName = snapshot.data?['parentFullName'] ?? '';
                String parentName = snapshot.data?['parentName'] ?? '';
                String parentPhoneNumber =
                    snapshot.data?['parentPhoneNumber'] ?? '';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              snapshot.data?['profilePicture'] ?? '',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Full Name: $parentFullName",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Name: $parentName",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Phone Number: $parentPhoneNumber",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ParentEditProfile(currentUserId: widget.currentUserId),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[400],
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
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
                      title: "Settings",
                      icon: Icons.settings,
                      onPress: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingPage(currentUserId: '',),
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
                      title: "Logout",
                      icon: Icons.logout,
                      textColor: Colors.purple,
                      endIcon: false,
                      onPress: _showLogoutConfirmationDialog,
                    ),
                  ],
                );
              }
            },
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
            icon: Icon(Icons.car_crash_outlined),
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

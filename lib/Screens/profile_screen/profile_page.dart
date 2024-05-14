import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp3/Screens/login_screen/login_page.dart';
import 'package:get/get.dart';

import '../../widget/profile_menu.dart';
import '../child_screen/child_homepage.dart';
import '../child_screen/child_profile.dart';
import '../home_screen/homepage.dart';
import '../settings_screen/settings_page.dart';
import '../settings_screen/system_info.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final String currentUserId;

  const ProfilePage({required this.currentUserId});

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
        // Do nothing, already on ProfilePage
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
                String parentEmail = snapshot.data?['parentEmail'] ?? '';
                String parentPassword = snapshot.data?['parentPassword'] ?? '';
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
                            "Email: $parentEmail",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Password: $parentPassword",
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
                        primary: Colors.purple[400],
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
                      title: "Child Information",
                      icon: Icons.child_care,
                      onPress: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChildInfoPage(),
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
                      textColor: Colors.red,
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
            icon: Icon(Icons.child_care_rounded),
            label: 'Child',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

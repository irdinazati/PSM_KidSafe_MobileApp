import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp3/Screens/child_screen/child_profile.dart';
import 'package:fyp3/Screens/vehicle_monitoring_screen/vehicle_monitoring_page.dart';

import '../home_screen/homepage.dart';
import '../profile_screen/profile_page.dart';
import '../settings_screen/settings_page.dart';

class UpdateChildProfile extends StatefulWidget {
  final String? childId;
  final String currentUserId;
  const UpdateChildProfile({required this.childId, required this.currentUserId});

  @override
  _UpdateChildProfileState createState() => _UpdateChildProfileState();
}

class _UpdateChildProfileState extends State<UpdateChildProfile> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadChildInfo();
  }

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
  
  void _loadChildInfo() async {
    try {
      String parentId = _auth.currentUser?.uid ?? '';
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('parents')
          .doc(parentId)
          .collection('children')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> childSnapshot = querySnapshot.docs.first;
        setState(() {
          fullNameController.text = childSnapshot['childFullName'];
          nicknameController.text = childSnapshot['childNickname'];
          ageController.text = childSnapshot['childAge'];
          genderController.text = childSnapshot['childGender'];
        });
      }
    } catch (error) {
      print('Error loading child info: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: Text("Update Child Profile"),
          leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black), // Use a color that fits your design
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/child3.png', // Replace this with your image path
              height: 150, // Adjust the height as needed
              width: double.infinity, // Take up the entire width
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormField('Full Name', fullNameController, 'Please enter full name'),
                    SizedBox(height: 16),
                    _buildFormField('Nickname', nicknameController, null),
                    SizedBox(height: 16),
                    _buildFormField('Age', ageController, null, keyboardType: TextInputType.number),
                    SizedBox(height: 16),
                    _buildFormField('Gender', genderController, null, isReadOnly: true),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _updateChildProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[200],
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                        ),
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
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

  Widget _buildFormField(String label, TextEditingController controller,
      String? validationMessage,
      {TextInputType? keyboardType, bool isReadOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(12),
          filled: true,
          fillColor: Colors.white,
        ),
        readOnly: isReadOnly,
        onTap: () {
          if (label == 'Gender') {
            _showGenderSelectionDialog(controller);
          }
        },
      ),
    );
  }

  void _showGenderSelectionDialog(TextEditingController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    controller.text = 'Girl'; // Update gender to Female
                  });
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Girl'),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    controller.text = 'Boy'; // Update gender to Male
                  });
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Boy'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateChildProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      String fullName = fullNameController.text;
      String nickname = nicknameController.text;
      String age = ageController.text;
      String gender = genderController.text;

      String parentId = _auth.currentUser?.uid ?? '';

      // Debug statements
      print('Child ID: ${widget.childId}');
      print('Parent ID: $parentId');


      await _firestore
          .collection('parents')
          .doc(parentId)
          .collection('children')
          .doc(widget.childId)
          .update({
        'childFullName': fullName,
        'childNickname': nickname,
        'childAge': age,
        'childGender': gender,
      });

      await _firestore.collection('system_log').add({
        'userId': parentId,
        'action': 'Child Profile Updated',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Child profile updated successfully'),
        ),
      );

      // Navigate back to previous screen after updating
      Navigator.pop(context);
    } catch (error) {
      print('Error updating child profile: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating child profile: $error'),
        ),
      );
    }
  }
}

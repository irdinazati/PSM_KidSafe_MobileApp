import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp3/Screens/vehicle_monitoring_screen/vehicle_monitoring_page.dart';
import '../home_screen/homepage.dart';
import '../profile_screen/profile_page.dart';
import '../settings_screen/settings_page.dart';
import 'child_homepage.dart';

class AddChildProfile extends StatefulWidget {
  @override
  _AddChildProfileState createState() => _AddChildProfileState();
}

class _AddChildProfileState extends State<AddChildProfile> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: Text("Add Child Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context// Pass childId here
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image widget added here
            Image.asset(
              'assets/child4.png', // Replace this with your image path
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
                    _buildFormField(
                        'Full Name', fullNameController, 'Please enter full name'),
                    SizedBox(height: 16),
                    _buildFormField('Nickname', nicknameController, null),
                    SizedBox(height: 16),
                    _buildFormField('Age', ageController, null,
                        keyboardType: TextInputType.number),
                    SizedBox(height: 16),
                    _buildFormField('Gender', genderController, null),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _createChildProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[200],
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                        ),
                        child: Text(
                          "Add Child",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Add the button for editing profile
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, String? validationMessage,
      {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label == 'Full Name')
          Row(
            children: [
              SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        if (label != 'Full Name') // Display label only if it's not the full name field
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        SizedBox(height: 8),
        if (label == 'Gender') // Gender dropdown
          DropdownButtonFormField<String>(
            value: controller.text.isNotEmpty ? controller.text : null, // Fix for empty value
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (newValue) {
              setState(() {
                controller.text = newValue!;
              });
            },
            items: ['Girl', 'Boy'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        if (label != 'Gender' && label != 'Age') // Regular text field for other fields
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              hintText: 'Enter $label',
            ),
            validator: (value) {
              if (validationMessage != null && (value == null || value.isEmpty)) {
                return validationMessage;
              }
              return null;
            },
            keyboardType: keyboardType,
          ),
        if (label == 'Age') // Age text field
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              hintText: 'Enter $label',
            ),
            validator: (value) {
              if (validationMessage != null && (value == null || value.isEmpty)) {
                return validationMessage;
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
      ],
    );
  }

  Future<String> _fetchChildId() async {
    // Implement the logic to fetch the child ID here
    // For now, return an empty string
    return '';
  }

  Future<void> _createChildProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      String fullName = fullNameController.text;
      String nickname = nicknameController.text;
      String age = ageController.text;
      String gender = genderController.text;

      String parentId = _auth.currentUser?.uid ?? '';

      // Add the child profile document to Firestore
      DocumentReference childRef = await _firestore
          .collection('parents')
          .doc(parentId)
          .collection('children')
          .add({
        'childFullName': fullName,
        'childNickname': nickname,
        'childAge': age,
        'childGender': gender,
      });

      // Get the ID of the newly added child
      String childId = childRef.id;
      print('childIDD = $childId');

      await _firestore.collection('system_log').add({
        'userId': parentId,
        'action': 'Child Profile Created',
        'childId': childId, // Include childId in system log
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Child profile created successfully'),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChildInfoPage()), // Pass childId here
      );
    } catch (error) {
      print('Error creating child profile: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating child profile: $error'),
        ),
      );
    }
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
}
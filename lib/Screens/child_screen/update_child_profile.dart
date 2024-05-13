import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateChildProfile extends StatefulWidget {
  final String childId;

  const UpdateChildProfile({required this.childId});

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

  void _loadChildInfo() async {
    try {
      String parentId = _auth.currentUser?.uid ?? '';
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _firestore
          .collection('parents')
          .doc(parentId)
          .collection('children')
          .doc(widget.childId)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          fullNameController.text = documentSnapshot['childFullName'];
          nicknameController.text = documentSnapshot['childNickname'];
          ageController.text = documentSnapshot['childAge'];
          genderController.text = documentSnapshot['childGender'];
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
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              child: Image.asset(
                'assets/child3.png', // Replace 'your_image.jpg' with your image path
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20), // Added SizedBox for spacing
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
                          primary: Colors.purple[200],
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Update",
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
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, String? validationMessage,
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
        validator: (value) {
          if (validationMessage != null && (value == null || value.isEmpty)) {
            return validationMessage;
          }
          return null;
        },
        keyboardType: keyboardType,
        readOnly: isReadOnly,
        onTap: () {
          if (label == 'Gender') {
            // Show gender selection dropdown
            FocusScope.of(context).requestFocus(FocusNode());
            _showGenderSelectionDialog(controller);
          }
        },
      ),
    );
  }

  // Method to show gender selection dialog
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
                    controller.text = 'Female'; // Update gender to Female
                  });
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Female'),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    controller.text = 'Male'; // Update gender to Male
                  });
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Male'),
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

      Navigator.pop(context); // Close the page after updating
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

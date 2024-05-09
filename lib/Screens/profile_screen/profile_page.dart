import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _parentFullNameController = TextEditingController();
  final TextEditingController _parentEmailController = TextEditingController();
  final TextEditingController _parentPhoneController = TextEditingController();
  final TextEditingController _parentPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _parentId;

  @override
  void initState() {
    super.initState();
    // Load parent data when the page is initialized
    _loadParentData();
  }

  Future<void> _loadParentData() async {
    try {
      // Get the current user's ID
      _parentId = _auth.currentUser!.uid;

      // Retrieve parent data from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('parents').doc(_parentId).get();

      if (snapshot.exists) {
        setState(() {
          // Update text controllers with parent information
          _parentNameController.text = snapshot['parentName'];
          _parentFullNameController.text = snapshot['parentFullName'];
          _parentEmailController.text = snapshot['parentEmail'];
          _parentPasswordController.text = snapshot['parentPassword'];
          _parentPhoneController.text = snapshot['parentPhoneNumber'];
          // Other fields can be updated similarly
        });
      }
    } catch (error) {
      print('Error loading parent data: $error');
    }
  }

  Future<void> _updateParentInfo() async {
    try {
      // Get updated values from text controllers
      String parentName = _parentNameController.text.trim();
      String parentFullName = _parentFullNameController.text.trim();
      String parentEmail = _parentEmailController.text.trim();
      String parentPassword = _parentPasswordController.text.trim();
      String parentPhone = _parentPhoneController.text.trim();
      // Other fields can be retrieved similarly

      // Update parent information in Firestore
      await _firestore.collection('parents').doc(_parentId).update({
        'parentName': parentName,
        'parentFullName': parentFullName,
        'parentEmail': parentEmail,
        'parentPassword': parentPassword,
        'parentPhoneNumber': parentPhone,
        // Update other fields as needed
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Parent information updated successfully'),
        ),
      );
    } catch (error) {
      print('Error updating parent information: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating parent information: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Parent Profile',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.purple[200],
        actions: [
          IconButton(
            onPressed: _updateParentInfo,
            icon: Icon(Icons.save),
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/profile_picture.jpg'), // Add your image asset here
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Parent Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
            SizedBox(height: 16),
            _buildTextField('Parent Name', _parentNameController),
            SizedBox(height: 16),
            _buildTextField('Parent Full Name', _parentFullNameController),
            SizedBox(height: 16),
            _buildTextField('Parent Email', _parentEmailController),
            SizedBox(height: 16),
            _buildTextField('Parent Password', _parentPasswordController, obscureText: true),
            SizedBox(height: 16),
            _buildTextField('Parent Phone', _parentPhoneController),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to edit profile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ParentEditProfile(currentUserId: '',)),
                  );
                },
                child: Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(12),
        labelStyle: TextStyle(color: Colors.purple),
      ),
    );
  }
}


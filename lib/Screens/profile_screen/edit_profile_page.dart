import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp3/Screens/home_screen/homepage.dart';
import 'package:fyp3/Screens/profile_screen/profile_page.dart';
import 'package:fyp3/Screens/vehicle_monitoring_screen/vehicle_monitoring_page.dart';
import 'package:image_picker/image_picker.dart';

import '../../Controller/parentRegistration.dart';
import '../settings_screen/settings_page.dart';

class ParentEditProfile extends StatefulWidget {
  final String currentUserId;

  const ParentEditProfile({required this.currentUserId});
  @override
  State<ParentEditProfile> createState() => _ParentEditProfileState();
}

class _ParentEditProfileState extends State<ParentEditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _controller = ParentRegistrationController();
  TextEditingController parentNameController = TextEditingController();
  TextEditingController parentFullNameController = TextEditingController();
  TextEditingController parentEmailController = TextEditingController();
  TextEditingController parentPhoneController = TextEditingController();
  TextEditingController parentPasswordController = TextEditingController();
  TextEditingController parentRePasswordController = TextEditingController();
  File? _imageFile;
  final imagePicker = ImagePicker();
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;

  // Fetch parent data from Firestore
  Future<Map<String, dynamic>> _fetchParentData() async {
    User? parent = _auth.currentUser;

    try {
      if (parent != null) {
        DocumentSnapshot documentSnapshot =
        await _firestore.collection('parents').doc(parent.uid).get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> parentData =
          documentSnapshot.data() as Map<String, dynamic>;
          parentData['profilePicture'] = parentData['profilePicture'] ?? '';
          parentData['parentName'] = parentData['parentName'] ?? '';
          parentData['parentFullName'] = parentData['parentFullName'] ?? '';
          parentData['parentPassword'] = parentData['parentPassword'] ?? '';
          parentData['parentRePassword'] = parentData['parentRePassword'] ?? '';
          parentData['parentPhoneNumber'] =
              parentData['parentPhoneNumber'] ?? '';
          parentData['role'] = parentData['role'] ?? '';

          // Update text controllers with fetched data
          parentNameController.text = parentData['parentName'];
          parentFullNameController.text = parentData['parentFullName'];
          parentPhoneController.text = parentData['parentPhoneNumber'];
          parentEmailController.text = parentData['parentEmail'];
          parentPasswordController.text = parentData['parentPassword'];
          parentRePasswordController.text = parentData['parentRePassword'];

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

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> _uploadImage() async {
    if (_imageFile != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance
          .ref()
          .child('profile_images/$fileName.jpg');

      UploadTask uploadTask = reference.putFile(_imageFile!);
      TaskSnapshot storageTaskSnapshot = await uploadTask;

      String downloadURL = await storageTaskSnapshot.ref.getDownloadURL();
      return downloadURL;
    }
    return null;
  }

  // Method to update the parent profile
  Future<void> updateParentProfile() async {
  try {
    User? parent = _auth.currentUser;
    if (parent != null) {
      // Update the profile picture if a new image is selected
      if (_imageFile != null) {
        String? profilePictureURL = await _uploadImage();
        await _firestore
            .collection('parents')
            .doc(parent.uid)
            .update({'profilePicture': profilePictureURL});
      }

      // Update all profile information
      await _firestore.collection('parents').doc(parent.uid).update({
        'parentName': parentNameController.text,
        'parentFullName': parentFullNameController.text,
        'parentPhoneNumber': parentPhoneController.text,
        'parentEmail': parentEmailController.text,
        'parentPassword': parentPasswordController.text,
        'parentRePassword': parentRePasswordController.text,
      });

      // Show success message or navigate to a different screen
      print('Profile updated successfully!');

      // Show a success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Profile updated successfully!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(currentUserId: parent.uid)),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  } catch (error) {
    print('Error updating profile: $error');
    // Show an error dialog if needed
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to update profile. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        title: Text(
          "Parent Update Profile",
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left, // Align text to the left
        ),
          leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black), // Use a color that fits your design
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
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
                String parentName = snapshot.data?['parentName'] ?? '';
                String parentFullName =
                    snapshot.data?['parentFullName'] ?? '';
                String parentEmail = snapshot.data?['parentEmail'] ?? '';
                String parentPhoneNumber =
                    snapshot.data?['parentPhoneNumber'] ?? '';
                String parentPassword = snapshot.data?['parentPassword'] ?? '';
                String parentRePassword =
                    snapshot.data?['parentRePassword'] ?? '';
                return Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              snapshot.data?['profilePicture'] ?? '',
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.amberAccent,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.add_photo_alternate),
                              onPressed: _pickImage,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        hintText: parentFullName,
                      ),
                      controller: parentFullNameController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: parentName,
                      ),
                      controller: parentNameController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: parentPhoneNumber,
                      ),
                      keyboardType: TextInputType.phone,
                      controller: parentPhoneController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: parentEmail,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: parentEmailController,
                    ),
                    TextFormField(
                      obscureText: _obscurePassword1, // Toggle password visibility
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: '********',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword1
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword1 = !_obscurePassword1;
                            });
                          },
                        ),
                      ),
                      controller: parentPasswordController,
                    ),
                    TextFormField(
                      obscureText: _obscurePassword2, // Toggle password visibility
                      decoration: InputDecoration(
                        labelText: 'Re-enter Password',
                        hintText: '********',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword2
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword2 = !_obscurePassword2;
                            });
                          },
                        ),
                      ),
                      controller: parentRePasswordController,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          updateParentProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[200],
                        ),
                        child: Text(
                          'Save Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
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
}

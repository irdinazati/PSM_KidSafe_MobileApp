import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../login_screen/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _parentNameEditingController =
  TextEditingController();
  final TextEditingController _parentFullNameEditingController =
  TextEditingController();
  final TextEditingController _parentEmailEditingController =
  TextEditingController();
  final TextEditingController _parentPhoneEditingController =
  TextEditingController();
  final TextEditingController _parentPasswordEditingController =
  TextEditingController();
  final TextEditingController _parentRePassEditingController =
  TextEditingController();

  File? _imageFile;
  final imagePicker = ImagePicker();

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
      Reference reference =
      FirebaseStorage.instance.ref().child('profile_images/$fileName.jpg');

      UploadTask uploadTask = reference.putFile(_imageFile!);
      TaskSnapshot storageTaskSnapshot = await uploadTask;

      String downloadURL = await storageTaskSnapshot.ref.getDownloadURL();
      return downloadURL;
    }
    return null;
  }

  Future<void> _registerUser() async {
    try {
      String pName = _parentNameEditingController.text.trim();
      String pFullName = _parentFullNameEditingController.text.trim();
      String pEmail = _parentEmailEditingController.text.trim();
      String pPhone = _parentPhoneEditingController.text.trim();
      String pPassword = _parentPasswordEditingController.text.trim();
      String pRePassword = _parentRePassEditingController.text.trim();
      String pRole = "parent";
      String pStatus = "Active";

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: _parentEmailEditingController.text.trim(),
          password: _parentPasswordEditingController.text.trim());

      // Add user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _parentEmailEditingController.text.trim(),
        // Add additional fields as needed
      });

      // Add parent data to Firestore
      String imageUrl = '';
      if (_imageFile != null) {
        imageUrl = await _uploadImage() ?? '';
      }

      await FirebaseFirestore.instance
          .collection('parents')
          .doc(userCredential.user!.uid)
          .set({
        'parentName': pName,
        'parentFullName': pFullName,
        'parentEmail': pEmail,
        'parentPhoneNumber': pPhone,
        'parentPassword': pPassword,
        'parentRePassword': pRePassword,
        'role': pRole,
        'status': pStatus,
        'profilePicture': imageUrl, // Add image URL to Firestore
      });

      // Navigate to the login page after successful registration
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50], // Set the background color
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[50],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset(
                    'assets/signup.png', // Add your image asset here
                    height: 250, // Increase the height of the image
                    width: 250, // Increase the width of the image
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[200],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Create an account, It's free",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 20), // Add SizedBox for spacing
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.purple[200],
                      child: _imageFile != null
                          ? ClipOval(
                        child: Image.file(
                          _imageFile!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),

                  SizedBox(height: 20), // Add SizedBox for spacing
                ],
              ),
              makeInput(
                label: "Parent Name",
                controller: _parentNameEditingController,
              ),
              makeInput(
                label: "Parent Full Name",
                controller: _parentFullNameEditingController,
              ),
              makeInput(
                label: "Parent Email",
                controller: _parentEmailEditingController,
              ),
              makeInput(
                label: "Parent Phone",
                controller: _parentPhoneEditingController,
              ),
              makeInput(
                label: "Parent Password",
                obscureText: true,
                controller: _parentPasswordEditingController,
                isPassword: true,
              ),
              makeInput(
                label: "Confirm Parent Password",
                obscureText: true,
                controller: _parentRePassEditingController,
                isPassword: true,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border(
                    bottom: BorderSide(color: Colors.black),
                    top: BorderSide(color: Colors.black),
                    left: BorderSide(color: Colors.black),
                    right: BorderSide(color: Colors.black),
                  ),
                ),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: _registerUser,
                  color: Colors.purple[200],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account?"),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the LoginPage when the "Login" text is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      " Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.purple[200],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput({
    label,
    obscureText = false,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          obscureText: obscureText,
          controller: controller,
          // Add password length validation
          onChanged: (value) {
            if (isPassword && value.length < 6) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Password must be at least 6 characters"),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          decoration: InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
        SizedBox(height: 20), // Reduced height to make it more compact
      ],
    );
  }
}

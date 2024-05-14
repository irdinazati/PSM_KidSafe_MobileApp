import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp3/Screens/login_screen/login_page.dart';
import 'package:fyp3/Screens/settings_screen/system_info.dart';
import '../../Constants/Constants.dart';
import '../../services/databaseServices.dart';
import '../feedback_screen/feedback_page.dart';
import '../home_screen/homepage.dart';

class SettingPage extends StatelessWidget {
  final String? currentUserId;

  const SettingPage({required this.currentUserId});

  Future<void> handleDeactivateAccount(BuildContext context) async {
    bool? confirmDeactivation = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deactivation"),
          content: Text("Are you sure you want to deactivate your account?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
            ),
          ],
        );
      },
    );
    if (confirmDeactivation != null && confirmDeactivation) {
      // User confirmed, perform account deactivation
      DatabaseServices databaseServices = DatabaseServices();
      await databaseServices.softDeleteUser(currentUserId);

      // Redirect to login or home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings'),
        backgroundColor: KidSafeColor2, // Set app bar color to green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SystemInfo(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'About Us',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: KidSafeColor2, // Set button color to green
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                handleDeactivateAccount(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Deactivate Account',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: KidSafeColor2,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

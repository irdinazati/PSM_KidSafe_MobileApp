import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fyp3/Screens/login_screen/login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Colors.purple.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: FadeInUp(
                duration: Duration(milliseconds: 1000),
                child: Image.asset(
                  'assets/forgot.png',
                  height: MediaQuery.of(context).size.height / 2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
                child: Text(
                  'Enter your email address below to reset your password.',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the HomePage when the button is clicked
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  // Replace `HomePage()` with the page you want to navigate to
                  return LoginPage();
                }));
              },
              child: Center(child: Text('Reset Password')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade200,
                textStyle: TextStyle(fontSize: 16),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

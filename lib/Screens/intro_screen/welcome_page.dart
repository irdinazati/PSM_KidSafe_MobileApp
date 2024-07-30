import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../feedback_screen/feedback_list.dart';
import '../login_screen/login_page.dart';
import '../signup_screen/signup_page.dart';

class FeedbackModel {
  final String userId;
  final int rating;
  final String comment;
  final Timestamp timestamp;

  FeedbackModel({
    required this.userId,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> data) {
    return FeedbackModel(
      userId: data['userId'] ?? '',
      rating: data['rating'] ?? 0,
      comment: data['comment'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  String getFormattedDate() {
    DateTime date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}

class WelcomePage extends StatefulWidget {

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<FeedbackModel> feedbackList = [];

  @override
  void initState() {
    super.initState();
    loadFeedback();
  }

  Future<void> loadFeedback() async {
    List<FeedbackModel> feedback = await fetchFeedback();
    setState(() {
      feedbackList = feedback;
    });
  }

  Future<List<FeedbackModel>> fetchFeedback() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('feedback').get();
    return querySnapshot.docs.map((doc) {
      return FeedbackModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "Welcome to",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.purple[800],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    FadeInUp(
                      duration: Duration(milliseconds: 1200),
                      child: Text(
                        "KidSafe",
                        style: TextStyle(
                          color: Colors.purple[600],
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeInUp(
                      duration: Duration(milliseconds: 1400),
                      child: Image.asset(
                        'assets/images/logo1.png',
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1500),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder:
                              (context) => LoginPage()));
                        },
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeInUp(
                      duration: Duration(milliseconds: 1600),
                      child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.black),
                        ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder:
                                (context) => SignupPage()));
                          },
                          color: Color(0xFFBEC4ED),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  FadeInUp(
                    duration: Duration(milliseconds: 1500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Click here to see the"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return FeedbackListPage();
                            }));
                          },
                          child: Text(
                            ' Feedback',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



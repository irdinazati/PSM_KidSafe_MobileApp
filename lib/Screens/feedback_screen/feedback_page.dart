import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatefulWidget {
  final String? currentUserId;

  const FeedbackPage({required this.currentUserId});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double _rating = 0;
  String _comment = '';

  Future<void> _submitFeedback() async {
    try {
      print('userid = ${widget.currentUserId}');
      // Ensure you have a collection named 'feedback' in your Firestore
      await FirebaseFirestore.instance.collection('feedback').add({
        'userId': widget.currentUserId,
        'rating': _rating,
        'comment': _comment,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit feedback: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple[200],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/feedback.png',
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'Rate the app:',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: RatingBar.builder(
                initialRating: _rating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40.0,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.purple[200],
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
            ),
            SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your comments...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              onChanged: (value) {
                setState(() {
                  _comment = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.purple[200],
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

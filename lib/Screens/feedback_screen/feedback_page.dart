import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatefulWidget {
  final String? currentUserId;

  const FeedbackPage({required this.currentUserId});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double _rating = 0; // Initial rating set to 0
  String _comment = ''; // Empty comment string

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Feedback',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.purple[200],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0), // Padding for the entire body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/feedback.jpg', // Image asset for feedback
              height: 300, // Adjusted image height
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'Rate the app:', // Text prompting to rate the app
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: RatingBar.builder(
                initialRating: _rating, // Current rating value
                minRating: 0, // Minimum allowed rating
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5, // Total number of rating icons
                itemSize: 40.0, // Size of each rating icon
                itemBuilder: (context, _) => Icon(
                  Icons.star, // Star icon used for rating
                  color: Colors.purple[200], // Star icon color
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating; // Update the rating value
                  });
                },
              ),
            ),
            SizedBox(height: 40), // Vertical spacing
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your comments...',
                // Placeholder text for comment input
                border: OutlineInputBorder(), // Input border
              ),
              maxLines: 5, // Allowing multiline input with maximum 5 lines
              onChanged: (value) {
                setState(() {
                  _comment = value; // Update the comment value as the user types
                });
              },
            ),
            SizedBox(height: 20), // Vertical spacing
            ElevatedButton(
              onPressed: () {
                // Here you can handle the submission of feedback as per your requirements.
                // For this example, I'll print the rating and comment.
                print('Rating: $_rating');
                print('Comment: $_comment');
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.purple[200],
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
              child: Text('Submit'), // Text displayed on the button
            ),
          ],
        ),
      ),
    );
  }
}

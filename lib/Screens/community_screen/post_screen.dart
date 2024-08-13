import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitPost() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null &&
        _contentController.text.isNotEmpty &&
        _titleController.text.isNotEmpty) {
      setState(() {
        _isSubmitting = true; // Show loading state
      });

      try {
        // Fetch parent name from the parents collection using the user's email
        DocumentSnapshot? parentDoc = await FirebaseFirestore.instance
            .collection('parents')
            .where('parentEmail', isEqualTo: user.email)
            .limit(1)
            .get()
            .then((snapshot) => snapshot.docs.isNotEmpty ? snapshot.docs.first : null);

        String parentName = parentDoc != null ? parentDoc['parentName'] : 'Anonymous'; // Get name or set to 'Anonymous'

        // Now add the post to the posts collection
        await FirebaseFirestore.instance.collection('posts').add({
          'author': user.email,
          'authorName': parentName, // Use fetched parent name
          'content': _contentController.text,
          'title': _titleController.text,
          'likes': 0,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Clear the text fields after submission
        _titleController.clear();
        _contentController.clear();

        Navigator.pop(context); // Return to previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit post: $e')),
        );
      } finally {
        setState(() {
          _isSubmitting = false; // Hide loading state
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both title and content.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Post'),
        backgroundColor: Colors.purple[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Post Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Post Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitPost, // Disable button while submitting
              child: _isSubmitting
                  ? CircularProgressIndicator() // Show loading indicator
                  : Text('Submit Post'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[200],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _contentController = TextEditingController();

  Future<void> _submitPost() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null && _contentController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('posts').add({
        'author': user.email,
        'content': _contentController.text,
        'likes': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        backgroundColor: Colors.purple[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Post Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                primary: Colors.purple[200], // Background color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

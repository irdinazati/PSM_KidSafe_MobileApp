import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

import 'reply_screen.dart';

class PostWidget extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> postData;
  final String? currentUserId;
  final Timestamp? timestamp; // Add this line to accept timestamp

  PostWidget({
    required this.postId,
    required this.postData,
    this.currentUserId,
    required this.timestamp, // Accept timestamp
  });

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    final authorEmail = widget.postData['author'] ?? 'Anonymous';
    final content = widget.postData['content'] ?? '';
    final title = widget.postData['title'] ?? 'No Title';

    // Format the timestamp
    String formattedTimestamp = widget.timestamp != null
        ? DateFormat('yyyy-MM-dd – kk:mm').format(widget.timestamp!.toDate())
        : 'No timestamp';

    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Map<String, dynamic>?>(
              future: _fetchParentDetails(authorEmail),
              builder: (context, snapshot) {
                String displayName = 'Anonymous';
                String profilePictureUrl = 'https://via.placeholder.com/150';

                if (snapshot.connectionState == ConnectionState.waiting) {
                  profilePictureUrl = 'https://via.placeholder.com/150';
                } else if (snapshot.hasData && snapshot.data != null) {
                  displayName = snapshot.data!['parentName'] ?? 'Anonymous';
                  profilePictureUrl = snapshot.data!['profilePicture'] ?? 'https://via.placeholder.com/150';
                }

                return Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(profilePictureUrl),
                      radius: 20.0,
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          authorEmail,
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 5.0),
            Text(
              content,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              formattedTimestamp, // Display the formatted timestamp
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: _replyToPost,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _replyToPost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReplyScreen(postId: widget.postId),
      ),
    );
  }

  Future<Map<String, dynamic>?> _fetchParentDetails(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('parents')
        .where('parentEmail', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final parentDoc = querySnapshot.docs.first;
      return {
        'parentName': parentDoc['parentName'],
        'profilePicture': parentDoc['profilePicture'],
      };
    }
    return null; // Return null if no parent found
  }
}

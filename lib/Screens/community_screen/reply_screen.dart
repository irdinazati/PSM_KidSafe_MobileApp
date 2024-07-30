import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyScreen extends StatefulWidget {
  final String postId;

  ReplyScreen({required this.postId});

  @override
  _ReplyScreenState createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  final TextEditingController _replyController = TextEditingController();

  Future<void> _submitReply() async {
    if (_replyController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('replies').add({
        'author': 'current_user_email', // Replace with the current user's email or ID
        'content': _replyController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _replyController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Replies'),
        backgroundColor: Colors.purple[200],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('replies').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No replies available.'));
                } else {
                  final replies = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: replies.length,
                    itemBuilder: (context, index) {
                      final reply = replies[index];
                      final replyData = reply.data() as Map<String, dynamic>;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Text(
                            replyData['author'][0].toUpperCase(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        title: Text(replyData['author']),
                        subtitle: Text(replyData['content']),
                        trailing: Text(
                          _formatTimestamp(replyData['timestamp']),
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      labelText: 'Reply',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _submitReply(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _submitReply,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.month}/${date.day}/${date.year}';
    } else if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

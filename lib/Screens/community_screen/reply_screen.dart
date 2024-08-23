import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp3/Screens/home_screen/homepage.dart';
import 'package:fyp3/Screens/profile_screen/profile_page.dart';
import 'package:fyp3/Screens/vehicle_monitoring_screen/vehicle_monitoring_page.dart';

class ReplyScreen extends StatefulWidget {
  final String postId;

  const ReplyScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _ReplyScreenState createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  final TextEditingController _replyController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _submitReply() async {
    if (_replyController.text.isNotEmpty) {
      User? currentUser = _auth.currentUser;

      // Fetch parent details based on the current user's email
      final parentData = await _fetchParentDetails(currentUser?.email);

      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('replies').add({
        'author': currentUser?.email ?? 'Anonymous',
        'content': _replyController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'authorName': parentData?['parentName'] ?? 'Anonymous', // Store the parent's name
        'profilePicture': parentData?['profilePicture'], // Store the profile picture URL
      });

      _replyController.clear();
    }
  }

  Future<Map<String, dynamic>?> _fetchParentDetails(String? email) async {
    if (email == null) return null;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('parents')
        .where('parentEmail', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final parentDoc = querySnapshot.docs.first;
      return {
        'parentName': parentDoc['parentName'],
        'profilePicture': parentDoc['profilePicture'], // Fetch the profile picture URL
      };
    }
    return null; // Return null if no parent found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Replies'),
        backgroundColor: Colors.purple[200],
          leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black), // Use a color that fits your design
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('replies')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
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
                          backgroundImage: NetworkImage(replyData['profilePicture'] ?? 'https://via.placeholder.com/150'), // Display profile picture
                          radius: 20.0,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(replyData['authorName'] ?? 'Anonymous', // Display parent's name
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              replyData['author'], // Display email below the name
                              style: TextStyle(fontSize: 12.0, color: Colors.grey),
                            ),
                          ],
                        ),
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
      // bottomNavigationBar: ConvexAppBar.badge(
      //   {0: '99+', 1: Icons.assistant_photo, 2: Colors.redAccent},
      //   items: [
      //     TabItem(icon: Icons.home, title: 'Home'),
      //     TabItem(icon: Icons.person, title: 'Profile'),
      //     TabItem(icon: Icons.car_crash_outlined, title: 'Vehicle Monitoring'),
      //   ],
      //   onTap: (int i) {
      //     switch (i) {
      //       case 0:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => HomePage()),
      //         );
      //         break;
      //       case 1:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => ProfilePage(currentUserId: '')),
      //         );
      //         break;
      //       case 2:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => VehicleMonitoringPage(sensorName: '',)),
      //         );
      //         break;
      //     }
      //   },
      // ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
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

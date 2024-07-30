import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp3/Screens/community_screen/reply_screen.dart';
import 'post_screen.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Feed'),
        backgroundColor: Colors.purple[200],
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('content', isGreaterThanOrEqualTo: _searchKeyword)
            .where('content', isLessThanOrEqualTo: '$_searchKeyword\uf8ff')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No posts available.'));
          } else {
            final posts = snapshot.data!.docs;

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return PostWidget(
                  postId: post.id,
                  postData: post.data() as Map<String, dynamic>,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPostScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple[200],
      ),
    );
  }

  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search Posts'),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(hintText: 'Enter keyword'),
            onSubmitted: (value) {
              setState(() {
                _searchKeyword = value;
              });
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              child: Text('Search'),
              onPressed: () {
                setState(() {
                  _searchKeyword = _searchController.text;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class PostWidget extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> postData;

  PostWidget({required this.postId, required this.postData});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    // Assuming you have a way to get the current user's ID
    final userId = 'currentUserId';
    final doc = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('likes')
        .doc(userId)
        .get();
    setState(() {
      _isLiked = doc.exists;
    });
  }

  void _toggleLikePost() {
    final userId = 'currentUserId';
    if (_isLiked) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('likes')
          .doc(userId)
          .delete();
      FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
        'likes': FieldValue.increment(-1),
      });
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('likes')
          .doc(userId)
          .set({});
      FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
        'likes': FieldValue.increment(1),
      });
    }
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _replyToPost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReplyScreen(postId: widget.postId),
      ),
    );
  }

  Future<String?> _fetchProfilePicture(String email) async {
    final parentDoc = await FirebaseFirestore.instance.collection('parents').doc(email).get();
    if (parentDoc.exists && parentDoc.data() != null) {
      return parentDoc.data()!['profilePictureUrl'] as String?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final author = widget.postData['author'] ?? 'Anonymous';
    final authorName = widget.postData['authorName'] ?? 'Anonymous';
    final content = widget.postData['content'] ?? '';
    final likes = widget.postData['likes'] ?? 0;

    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String?>(
              future: _fetchProfilePicture(author),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 20.0,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        authorName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 20.0,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        authorName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  );
                }
                final profilePictureUrl = snapshot.data ?? 'https://via.placeholder.com/150';
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(profilePictureUrl),
                      radius: 20.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      authorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 10.0),
            Text(
              content,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        color: _isLiked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: _toggleLikePost,
                    ),
                    Text(likes.toString()),
                  ],
                ),
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
}

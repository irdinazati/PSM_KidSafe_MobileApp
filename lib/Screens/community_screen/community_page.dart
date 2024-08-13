import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post_screen.dart';
import 'post_widget.dart';

class CommunityScreen extends StatefulWidget {
  final String? currentUserId;

  const CommunityScreen({Key? key, this.currentUserId}) : super(key: key);

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
            onPressed: showSearchDialog,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('title', isGreaterThanOrEqualTo: _searchKeyword)
            .where('title', isLessThanOrEqualTo: '$_searchKeyword\uf8ff')
            .snapshots(),
        builder: (context, titleSnapshot) {
          if (titleSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (titleSnapshot.hasError) {
            return Center(child: Text('Error: ${titleSnapshot.error}'));
          }

          final titlePosts = titleSnapshot.data!.docs;

          return ListView.builder(
            itemCount: titlePosts.length,
            itemBuilder: (context, index) {
              final post = titlePosts[index];

              return PostWidget(
                postId: post.id,
                postData: post.data() as Map<String, dynamic>,
                currentUserId: widget.currentUserId,
                timestamp: post['timestamp'], // Pass the timestamp to PostWidget
              );
            },
          );
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
            onChanged: (value) {
              setState(() {
                _searchKeyword = value;
              });
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
            TextButton(
              child: Text('Clear'),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchKeyword = '';
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

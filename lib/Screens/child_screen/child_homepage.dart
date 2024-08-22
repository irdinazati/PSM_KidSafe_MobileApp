import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp3/Screens/child_screen/feeling_summary.dart';
import '../../Models/child.dart';
import 'add_child.dart';
import 'add_feelings.dart';
import 'child_profile.dart';
import 'tracking.dart'; // Adjust the import based on your project structure

class ChildInfoPage extends StatefulWidget {
  final String? currentUserId;

  const ChildInfoPage({Key? key, this.currentUserId}) : super(key: key);

  @override
  _ChildInfoPageState createState() => _ChildInfoPageState();
}

class _ChildInfoPageState extends State<ChildInfoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _feelingsController = TextEditingController();
  String? _selectedFeeling;
  String? _selectedChildId;
  List<ChildModel> _children = [];
  List<String> _feelingsOptions = ['Happy', 'Sad', 'Angry', 'Excited', 'Tired'];

  @override
  void initState() {
    super.initState();
    _loadChildInfo();
  }

  Future<void> _loadChildInfo() async {
    try {
      String parentId = _auth.currentUser?.uid ?? '';
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('parents')
          .doc(parentId)
          .collection('children')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<ChildModel> children = querySnapshot.docs.map((doc) {
          return ChildModel.fromDoc(doc);
        }).toList();

        setState(() {
          _children = children;
        });
      }
    } catch (error) {
      print('Error loading child info: $error');
    }
  }

  Future<void> _submitFeeling() async {
    if (_selectedFeeling != null && _selectedChildId != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> childDoc = await _firestore
            .collection('parents')
            .doc(_auth.currentUser?.uid)
            .collection('children')
            .doc(_selectedChildId)
            .get();

        if (childDoc.exists) {
          String childName = childDoc.data()?['childFullName'] ?? 'Unknown';

          await _firestore.collection('child_feelings').add({
            'userId': _auth.currentUser?.uid,
            'childId': _selectedChildId,
            'childName': childName,
            'feeling': _selectedFeeling,
            'date': DateTime.now(),
          });

          _showSuccessSnackbar('Feeling submitted successfully!');
          setState(() {
            _selectedFeeling = null;
            _selectedChildId = null;
          });
        } else {
          _showErrorSnackbar('Selected child does not exist.');
        }
      } catch (e) {
        _showErrorSnackbar('Error submitting feeling: $e');
      }
    } else {
      _showErrorSnackbar('Please select a feeling and a child.');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Child Information"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              FadeInUp(
                duration: Duration(milliseconds: 800),
                child: Image.asset(
                  'assets/child.png',
                  height: MediaQuery.of(context).size.height / 4,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              _buildMenuItem(
                title: "Display Child Profile",
                icon: Icons.child_care,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayChildProfile(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                title: "Add Child Profile",
                icon: Icons.add,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddChildProfile(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                title: "Daily Feelings Submission",
                icon: Icons.face,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFeelingsPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                title: "Summary of Child Feelings",
                icon: Icons.timeline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeelingsPage(
                          currentUserId: widget.currentUserId),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                title: "Drop-Off/Pick-Up Tracking",
                icon: Icons.car_crash,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DropOffPickUpTrackingPage(
                          currentUserId: widget.currentUserId),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      leading: Icon(icon, color: Colors.purple[700]),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      height: 20,
      thickness: 1,
      indent: 15,
      endIndent: 15,
    );
  }
}

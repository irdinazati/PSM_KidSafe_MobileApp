import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp3/Models/child.dart';

class AddFeelingsPage extends StatefulWidget {
  final String? currentUserId;

  const AddFeelingsPage({Key? key, this.currentUserId}) : super(key: key);
  @override
  _AddFeelingsPageState createState() => _AddFeelingsPageState();
}

class _AddFeelingsPageState extends State<AddFeelingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _feelingsController = TextEditingController();
  String? _selectedFeeling;
  String? _selectedChildId;
  List<ChildModel> _children = [];
  List<String> _feelingsOptions = ['😊 Happy', '😢 Sad', '😡 Angry', '😄 Excited', '😴 Tired'];

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
      SnackBar(content: Text(message, style: TextStyle(color: Colors.white))),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.white))),
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Add Feelings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'How are they feeling today?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[500],
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/feeling.jpg', // Add a cute illustration
                height: 150,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedChildId,
                decoration: InputDecoration(
                  labelText: 'Select Child',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.purple[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.purple[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.purple[500]!),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedChildId = newValue;
                  });
                },
                items: _children.map<DropdownMenuItem<String>>((child) {
                  return DropdownMenuItem<String>(
                    value: child.id,
                    child: Text(child.childName),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedFeeling,
                decoration: InputDecoration(
                  labelText: 'Select Feeling',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.purple[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.purple[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.purple[500]!),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFeeling = newValue;
                  });
                },
                items: _feelingsOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _submitFeeling,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purple[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 10,
                    shadowColor: Colors.purple[200],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.send, size: 24),
                      SizedBox(width: 10),
                      Text('Submit'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

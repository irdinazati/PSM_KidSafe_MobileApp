import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fyp3/Models/child.dart';

class FeelingsPage extends StatefulWidget {
  final String? currentUserId;

  const FeelingsPage({Key? key, this.currentUserId}) : super(key: key);

  @override
  _FeelingsPageState createState() => _FeelingsPageState();
}

class _FeelingsPageState extends State<FeelingsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _selectedFeeling;
  String? _selectedChildId;
  List<ChildModel> _children = [];
  Map<String, int> _feelingsCount = {
    '😊 Happy': 0,
    '😢 Sad': 0,
    '😡 Angry': 0,
    '😄 Excited': 0,
    '😴 Tired': 0,
  };
  List<PieChartSectionData> _pieChartData = [];
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
            'childFullName': childName,
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
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _loadFeelingsData(String childId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> feelingsSnapshot = await _firestore
          .collection('child_feelings')
          .where('childId', isEqualTo: childId)
          .get();

      // Reset feelings count
      Map<String, int> feelingsCount = {
        '😊 Happy': 0,
        '😢 Sad': 0,
        '😡 Angry': 0,
        '😄 Excited': 0,
        '😴 Tired': 0,
      };

      for (var doc in feelingsSnapshot.docs) {
        String feeling = doc.data()['feeling'];
        if (feelingsCount.containsKey(feeling)) {
          feelingsCount[feeling] = feelingsCount[feeling]! + 1;
        }
      }

      setState(() {
        _feelingsCount = feelingsCount;
        _preparePieChartData();
      });
    } catch (error) {
      print('Error loading feelings data: $error');
    }
  }

  void _preparePieChartData() {
    List<PieChartSectionData> pieChartData = [];

    _feelingsCount.forEach((feeling, count) {
      pieChartData.add(
        PieChartSectionData(
          color: _getColorForFeeling(feeling),
          value: count.toDouble(),
          title: '$feeling\n$count',
          radius: 100, // Adjusted radius for better fit
          titleStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      );
    });

    setState(() {
      _pieChartData = pieChartData;
    });
  }

  Color _getColorForFeeling(String feeling) {
    switch (feeling) {
      case '😊 Happy':
        return const Color.fromARGB(255, 232, 226, 184);
      case '😢 Sad':
        return const Color.fromARGB(255, 200, 223, 241);
      case '😡 Angry':
        return const Color.fromARGB(255, 213, 134, 128);
      case '😄 Excited':
        return const Color.fromARGB(255, 249, 207, 145);
      case '😴 Tired':
        return const Color.fromARGB(255, 187, 176, 176);
      default:
        return Colors.black;
    }
  }

  @override
Widget build(BuildContext context) {
  bool hasFeelings = _feelingsCount.values.any((count) => count > 0);

  return Scaffold(
    backgroundColor: Colors.purple[50],
    appBar: AppBar(
      elevation: 2,
      backgroundColor: Colors.purple[200],
      title: Text(
        "Feelings Summary",
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
        ),
      ),
      centerTitle: true,
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedChildId,
            decoration: InputDecoration(
              labelText: 'Select Child',
              labelStyle: TextStyle(color: Colors.purple[800]),
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
                if (newValue != null) {
                  _loadFeelingsData(newValue);
                }
              });
            },
            items: _children.map<DropdownMenuItem<String>>((child) {
              return DropdownMenuItem<String>(
                value: child.id,
                child: Text(child.childName),
              );
            }).toList(),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitFeeling,
            child: Text('Submit Feeling'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 229, 197, 235),
              padding: EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 24),
          if (hasFeelings)
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: PieChart(
                        PieChartData(
                          sections: _pieChartData,
                          centerSpaceRadius: 50,
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 2,
                          startDegreeOffset: 180,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  'No feelings recorded yet.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

}
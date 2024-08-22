import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../Models/child.dart';
import 'trackinglist.dart';

class DropOffPickUpTrackingPage extends StatefulWidget {
  final String? currentUserId;

  const DropOffPickUpTrackingPage({Key? key, this.currentUserId}) : super(key: key);

  @override
  _DropOffPickUpTrackingPageState createState() => _DropOffPickUpTrackingPageState();
}

class _DropOffPickUpTrackingPageState extends State<DropOffPickUpTrackingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _dropOffTimeController = TextEditingController();
  final TextEditingController _pickUpTimeController = TextEditingController();
  final TextEditingController _dropOffLocationController = TextEditingController();
  String? _selectedChildId;
  List<ChildModel> _children = [];

  @override
  void initState() {
    super.initState();
    _loadChildInfo();
    print(widget.currentUserId!);
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

  Future<void> _submitSchedule() async {
    if (_selectedChildId != null &&
        _dropOffTimeController.text.isNotEmpty &&
        _pickUpTimeController.text.isNotEmpty &&
        _dropOffLocationController.text.isNotEmpty) {
      try {
        DateTime dropOffTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(_dropOffTimeController.text);
        DateTime pickUpTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(_pickUpTimeController.text);

        // Find the selected child from the list
        ChildModel? selectedChild = _children.firstWhere(
          (child) => child.id == _selectedChildId,
          orElse: () => ChildModel(id: '', childFullName: 'Unknown', childName: '', childGender: '', childAge: null),
        );

        // Add drop-off schedule
        await _firestore.collection('drop_off_pick_up_schedules').add({
          'userId': _auth.currentUser?.uid,
          'childName': selectedChild.childFullName,
          'childId': _selectedChildId,
          'dropOffTime': dropOffTime,
          'pickUpTime': pickUpTime,
          'dropOffLocation': _dropOffLocationController.text,
          'date': DateTime.now(),
          'status': 'Scheduled', // Status to track if picked up
        });

        _showSuccessSnackbar('Schedule submitted successfully!');
        setState(() {
          _selectedChildId = null;
          _dropOffTimeController.clear();
          _pickUpTimeController.clear();
          _dropOffLocationController.clear();
        });
      } catch (e) {
        _showErrorSnackbar('Error submitting schedule: $e');
      }
    } else {
      _showErrorSnackbar('Please fill in all fields.');
    }
  }

  Future<void> _selectDateTime(TextEditingController controller, bool isDropOff) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime dateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        setState(() {
          controller.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
        });
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Drop-Off/Pick-Up", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Child',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple[700]),
            ),
            DropdownButtonFormField<String>(
              value: _selectedChildId,
              hint: Text('Select Child'),
              onChanged: (value) {
                setState(() {
                  _selectedChildId = value!;
                });
              },
              items: _children.map<DropdownMenuItem<String>>((ChildModel child) {
                return DropdownMenuItem<String>(
                  value: child.id,
                  child: Text(child.childFullName ?? 'Unknown'),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Drop-Off Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple[700]),
            ),
            GestureDetector(
              onTap: () => _selectDateTime(_dropOffTimeController, true),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dropOffTimeController,
                  decoration: InputDecoration(
                    labelText: 'Select Drop-Off Time',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Pick-Up Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple[700]),
            ),
            GestureDetector(
              onTap: () => _selectDateTime(_pickUpTimeController, false),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _pickUpTimeController,
                  decoration: InputDecoration(
                    labelText: 'Select Pick-Up Time',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Drop-Off Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple[700]),
            ),
            TextFormField(
              controller: _dropOffLocationController,
              decoration: InputDecoration(
                labelText: 'Enter Drop-Off Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _submitSchedule,
                    child: Text('Submit Schedule'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[100], // Light purple color
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DropOffPickUpListPage(currentUserId: widget.currentUserId!)),
                      );
                    },
                    child: Text('View Drop-Off/Pick-Up List'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[100], // Light purple color
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

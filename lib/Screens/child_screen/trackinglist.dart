import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import '../../Models/track.dart';
import 'notification.dart';

class DropOffPickUpListPage extends StatefulWidget {

  final String? currentUserId;

  const DropOffPickUpListPage({Key? key, this.currentUserId}) : super(key: key);
  @override
  _DropOffPickUpListPageState createState() => _DropOffPickUpListPageState();
}

class _DropOffPickUpListPageState extends State<DropOffPickUpListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<DropOffPickUpSchedule>> _schedules;

  @override
  void initState() {
    super.initState();
    _schedules = _loadSchedules();
    initiateNotifications(widget.currentUserId!); // Start sensor checks
  }

  Future<List<DropOffPickUpSchedule>> _loadSchedules() async {
    try {
      String parentId = _auth.currentUser?.uid ?? '';
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('drop_off_pick_up_schedules')
          .where('userId', isEqualTo: parentId)
          .get();

      return querySnapshot.docs.map((doc) {
        return DropOffPickUpSchedule.fromDoc(doc);
      }).toList();
    } catch (error) {
      print('Error loading schedules: $error');
      return [];
    }
  }

  Future<void> _markAsPickedUp(String scheduleId) async {
    try {
      await _firestore.collection('drop_off_pick_up_schedules').doc(scheduleId).update({
        'status': 'Picked Up',
      });

      setState(() {
        _schedules = _loadSchedules(); // Refresh the list
      });
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> _deleteSchedule(String scheduleId) async {
    try {
      await _firestore.collection('drop_off_pick_up_schedules').doc(scheduleId).delete();
      setState(() {
        _schedules = _loadSchedules(); // Refresh the list
      });
    } catch (e) {
      print('Error deleting schedule: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drop-Off/Pick-Up List'),
        centerTitle: true,
        backgroundColor: Colors.purple[100],
      ),
      body: FutureBuilder<List<DropOffPickUpSchedule>>(
        future: _schedules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No schedules found.'));
          } else {
            final schedules = snapshot.data!;
            return ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule.childName ?? 'Unknown Child', // Handle null case
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.purple[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Drop-Off Time: ${DateFormat('yyyy-MM-dd HH:mm').format(schedule.dropOffTime)}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Pick-Up Time: ${DateFormat('yyyy-MM-dd HH:mm').format(schedule.pickUpTime)}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Drop-Off Location: ${schedule.dropOffLocation ?? 'Unknown Location'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center the buttons horizontally
                          children: [
                            if (schedule.status == 'Scheduled') 
                              ElevatedButton(
                                onPressed: () => _markAsPickedUp(schedule.id),
                                child: Text('Mark as Picked Up'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple[200],
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _deleteSchedule(schedule.id),
                              child: Text('Delete'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple[200],
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

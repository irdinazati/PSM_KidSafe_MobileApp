import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp3/Screens/child_screen/update_child_profile.dart';
import 'package:fyp3/Screens/vehicle_monitoring_screen/vehicle_monitoring_page.dart';
import '../../Models/child.dart';
import '../home_screen/homepage.dart';
import '../profile_screen/profile_page.dart';
import '../settings_screen/settings_page.dart';
import 'child_homepage.dart';

class DisplayChildProfile extends StatefulWidget {
  @override
  _DisplayChildProfileState createState() => _DisplayChildProfileState();
}

class _DisplayChildProfileState extends State<DisplayChildProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 5;
  List<ChildModel> _children = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: Text("Child Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChildInfoPage()), // Pass childId here
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadChildInfo,
        child: _children.isEmpty
            ? Center(child: Text('No children found'))
            : ListView.builder(
          itemCount: _children.length,
          itemBuilder: (context, index) {
            final child = _children[index];
            return _buildChildProfile(child);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.car_crash_outlined),
            label: 'Vehicle Monitoring',
          ),

        ],
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildChildProfile(ChildModel child) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDisplayField('Full Name', child.childFullName),
            _buildDisplayField('Nickname', child.childName),
            _buildDisplayField('Age', child.childAge.toString()),
            _buildDisplayField('Gender', child.childGender),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateChildProfile(
                        childId: child.id!,
                        currentUserId: _auth.currentUser?.uid ?? '',
                      ),
                    ),
                  ).then((_) {
                    _loadChildInfo();
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple[400],
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$label: ",
              style: TextStyle(
                fontSize: 16,
                color: Colors.purple[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage(currentUserId: '')),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VehicleMonitoringPage(sensorName: '',)),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingPage(currentUserId: '')),
          );
          break;
      }
    });
  }
}

import 'package:flutter/material.dart';

class IncidentHistoryPage extends StatelessWidget {
  const IncidentHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incident History'),
        backgroundColor: Colors.purple.shade200, // Set app bar background color to purple
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20), // Add space at the top
                Text(
                  '1. Incident 1',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                SizedBox(height: 5),
                Text(
                  'Date: January 1, 2024',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Description: Child left alone in the car for 30 minutes.',
                  style: TextStyle(fontSize: 16),
                ),
                Divider(), // Add a divider for visual separation
                Text(
                  '2. Incident 2',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                SizedBox(height: 5),
                Text(
                  'Date: February 15, 2024',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Description: Child left alone in the car, temperature reached dangerous levels.',
                  style: TextStyle(fontSize: 16),
                ),
                Divider(), // Add a divider for visual separation
                // Add more incident entries as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}

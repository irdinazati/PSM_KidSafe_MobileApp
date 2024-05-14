import 'package:flutter/material.dart';
import 'package:fyp3/Screens/educational_resources_screen/educational_homepage.dart';
import 'educational_resources_page.dart';

class ParentingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parenting Tips'),
        backgroundColor: Colors.purple[200],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EducationalHomePage()), // Pass childId here
            );
          },
        ),
      ),
      body: Container(
        color: Colors.purple[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTipCard(
                        title: 'Establish Routine',
                        description:
                        'Set up a daily routine for your child to provide structure and predictability.',
                      ),
                      SizedBox(height: 16),
                      _buildTipCard(
                        title: 'Communicate',
                        description:
                        'Open communication helps build trust and strengthens the parent-child relationship.',
                      ),
                      SizedBox(height: 16),
                      _buildTipCard(
                        title: 'Lead by Example',
                        description:
                        'Children learn by observing, so be a positive role model for them.',
                      ),
                      SizedBox(height: 16),
                      _buildTipCard(
                        title: 'Show Affection',
                        description:
                        'Express love and affection regularly to foster emotional well-being.',
                      ),
                      SizedBox(height: 16),
                      _buildTipCard(
                        title: 'Set Limits',
                        description:
                        'Establish clear rules and boundaries to teach responsibility and respect.',
                      ),
                      SizedBox(height: 16),
                      _buildTipCard(
                        title: 'Be Patient',
                        description:
                        'Parenting can be challenging, so practice patience and understanding.',
                      ),
                      SizedBox(height: 16),
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

  Widget _buildTipCard(
      {required String title, required String description}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ParentingPage(),
  ));
}

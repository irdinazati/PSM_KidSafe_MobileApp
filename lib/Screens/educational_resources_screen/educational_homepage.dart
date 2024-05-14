import 'package:flutter/material.dart';
import 'package:fyp3/Screens/educational_resources_screen/parenting_page.dart';

import 'educational_resources_page.dart';

class EducationalHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Educational Resources'),
        backgroundColor: Colors.purple[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Types of Resources',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 160,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EducationalResourcesPage()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/youtube.png',
                            height: 100,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'YouTube',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple[100],
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 160,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ParentingPage()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/family.png',
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tips for Parenting',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple[100],
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Scrollable Images:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 16),
                  Image.asset(
                    'assets/child4.jpg',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16),
                  Image.asset(
                    'assets/child2.png',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16),
                  Image.asset(
                    'assets/child3.png',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EducationalHomePage(),
  ));
}

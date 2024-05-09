import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying an image using the Image widget
            Image.asset(
              'assets/images/car1.png',
              height: 150,
              width: 150,
            ),
            // Adding some spacing between the image and the text
            SizedBox(height: 20),
            // Displaying the text
            Text(
              'Remember: Child in the car!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({Key? key}) : super(key: key);

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
              'assets/images/car2.png',
              height: 150,
              width: 150,
            ),
            // Adding some spacing between the image and the text
            SizedBox(height: 20),
            // Displaying the text
            Text(
              'Check the back seat of car!',
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
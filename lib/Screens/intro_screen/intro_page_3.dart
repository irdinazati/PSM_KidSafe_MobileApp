import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({Key? key}) : super(key: key);

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
              'assets/images/car3.png',
              height: 150,
              width: 150,
            ),
            // Adding some spacing between the image and the text
            SizedBox(height: 20),
            // Displaying the text
            Text(
              'Do not forget your precious passenger!',
              textAlign: TextAlign.center, // Ensures the text is centered
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

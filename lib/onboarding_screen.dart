import 'package:flutter/material.dart';
import 'package:fyp3/Screens/intro_screen/intro_page_1.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'Screens/intro_screen/intro_page_2.dart';
import 'Screens/intro_screen/intro_page_3.dart';
import 'Screens/intro_screen/welcome_page.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();

}

  class _OnBoardingScreenState extends State<OnBoardingScreen> {

  PageController _controller = PageController();

  bool onLastPage = false;
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index){
                setState(() {
                  onLastPage = (index == 2);
                });
              },
              children: [
                IntroPage1(),
                IntroPage2(),
                IntroPage3(),
              ],
            ),

            Container(
              alignment: Alignment(0,0.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                  _controller.jumpToPage(2);
                  },
                      child: Text('Back')
                  ),

                  SmoothPageIndicator(controller: _controller, count: 3),

                  onLastPage
                      ? GestureDetector(
                      onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return WelcomePage();
                            }));
                      },
                      child: Text('Login'),
                      )

                      : GestureDetector(
                      onTap: () {
                          _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                    );
                  },
                  child: Text('Next'),
                  ),
                ]
              )
            ),
          ],
        )
      );
  }
}


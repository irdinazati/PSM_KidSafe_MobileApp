import 'package:flutter/material.dart';
import 'package:fyp3/Screens/api/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'onboarding_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingScreen(),
      theme: ThemeData(
        // Customize the bottom navigation bar theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.purple[200]
        ),
      ),
    );
  }
}

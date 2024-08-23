import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
<<<<<<< HEAD
import 'Screens/notification_screen/controllers.dart';
import 'onboarding_screen.dart';
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:fyp3/onboarding_screen.dart';
import 'package:fyp3/Screens/home_screen/homepage.dart';
import 'package:fyp3/Screens/notification_screen/controllers.dart';
>>>>>>> 6240b91 (new updated)
import 'dart:async';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();
<<<<<<< HEAD
  await FirebaseApi().initNotifications();

  // Initiate sensors and notifications
  await initiateSensorsAndNotifications();
=======

  // Initialize OneSignal (optional)
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("a4fa788b-f75d-41c4-aa0b-8d49595f74f8");
  OneSignal.Notifications.requestPermission(true);
  
  // Initialize Firebase Messaging and handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
>>>>>>> 6240b91 (new updated)

  runApp(MyApp());
}

<<<<<<< HEAD
Future<void> initiateSensorsAndNotifications() async {
  ThingSpeakController thingSpeakController = ThingSpeakController();
  TelegramController telegramController = TelegramController();

  double? lastTemperature;
  double? lastMotion;

  bool temperatureAlertSent = false;
  bool motionAlertSent = false;

  Timer.periodic(Duration(seconds: 5), (Timer timer) async {
    // Read sensor data from ThingSpeak
    Map<String, double> sensorData = await thingSpeakController.readSensorData();

    if (sensorData.isNotEmpty) {
      double temperature = sensorData['temperature']!;
      double motion = sensorData['motion']!;

      // Define the thresholds
      double temperatureThreshold = 38.0;
      double motionThreshold = 1.0;

      // Check if the temperature exceeds the threshold and if it has changed
      if (temperature > temperatureThreshold && temperature != lastTemperature) {
        lastTemperature = temperature;

        // Send temperature alert if not already sent
        if (!temperatureAlertSent) {
          temperatureAlertSent = true;
          await sendTemperatureAlert(telegramController, temperature);
        }
      }

      // Check if motion is detected and if it has changed
      if (motion >= motionThreshold && motion != lastMotion) {
        lastMotion = motion;

        // Send motion alert if not already sent
        if (!motionAlertSent) {
          motionAlertSent = true;
          await sendMotionAlert(telegramController);
        }
      }

      print("Temperature: $temperature, Motion: $motion");
    } else {
      print("Failed to retrieve sensor data.");
      timer.cancel(); // Stop the timer if data retrieval fails
    }
  });
}

Future<void> sendTemperatureAlert(TelegramController telegramController, double temperature) async {
  await telegramController.sendTelegramNotification(
    "🚨 Temperature Alert: Temperature has exceeded the threshold: $temperature°C"
  );

  await telegramController.sendTelegramNotification(
    "🚨 Temperature Alert: Temperature has exceeded the threshold: $temperature°C"
  );

  // Wait for 3 minutes before sending the reminder
  await Future.delayed(Duration(minutes: 3));
  
  await telegramController.sendTelegramNotification(
    "🔄 Reminder: High temperature still detected: $temperature°C"
  );
}

Future<void> sendMotionAlert(TelegramController telegramController) async {
  await telegramController.sendTelegramNotification(
    "🚨 Motion Alert: Motion has been detected!"
  );

  await telegramController.sendTelegramNotification(
    "🚨 Motion Alert: Motion has been detected!"
  );

  // Wait for 3 minutes before sending the reminder
  await Future.delayed(Duration(minutes: 3));
  
  await telegramController.sendTelegramNotification(
    "🔄 Reminder: Motion has been detected!"
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
=======
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          this.user = user;
          _loading = false;
        });
        if (user != null) {
          initiateSensorsAndNotifications();
        }
      });
    } else {
      setState(() {
        _loading = false;
      });
      initiateSensorsAndNotifications();
    }
  }

  Future<void> initiateSensorsAndNotifications() async {
    ThingSpeakController thingSpeakController = ThingSpeakController();
    TelegramController telegramController = TelegramController();

    double? lastTemperature;
    double? lastMotion;

    Timer.periodic(Duration(seconds: 5), (Timer timer) async {
      // Read sensor data from ThingSpeak
      Map<String, double> sensorData = await thingSpeakController.readSensorData();

      if (sensorData.isNotEmpty) {
        double temperature = sensorData['temperature']!;
        double motion = sensorData['motion']!;

        // Define the thresholds
        double temperatureThreshold = 38.0;
        double motionThreshold = 1.0;

        // Check if the temperature exceeds the threshold and if it has changed
        if (temperature > temperatureThreshold && temperature != lastTemperature) {
          lastTemperature = temperature;
          await sendTemperatureAlert(telegramController, temperature);
        }

        // Check if motion is detected and if it has changed
        if (motion >= motionThreshold && motion != lastMotion) {
          lastMotion = motion;
          await sendMotionAlert(telegramController);
        }

        print("Temperature: $temperature, Motion: $motion");
      } else {
        print("Failed to retrieve sensor data.");
        timer.cancel(); // Stop the timer if data retrieval fails
      }
    });
  }

  Future<void> sendTemperatureAlert(TelegramController telegramController, double temperature) async {
    await telegramController.sendTelegramNotification(
      "🚨 Temperature Alert: Temperature has exceeded the threshold: $temperature°C"
    );

    // Wait for 3 minutes before sending the reminder
    await Future.delayed(Duration(minutes: 3));
    
    await telegramController.sendTelegramNotification(
      "🔄 Reminder: High temperature still detected: $temperature°C"
    );
  }

  Future<void> sendMotionAlert(TelegramController telegramController) async {
    await telegramController.sendTelegramNotification(
      "🚨 Motion Alert: Motion has been detected!"
    );

    // Wait for 3 minutes before sending the reminder
    await Future.delayed(Duration(minutes: 3));
    
    await telegramController.sendTelegramNotification(
      "🔄 Reminder: Motion has been detected!"
    );
  }
>>>>>>> 6240b91 (new updated)

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.purple[200],
        ),
      ),
      home: user != null ? HomePage(currentUserId: user!.uid) : OnBoardingScreen(),
    );
  }
}

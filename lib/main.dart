import 'package:flutter/material.dart';
import 'package:fyp3/Screens/api/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/notification_screen/controllers.dart';
import 'onboarding_screen.dart';
import 'dart:async';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

  // Initiate sensors and notifications
  await initiateSensorsAndNotifications();

  runApp(MyApp());
}

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingScreen(),
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.purple[200],
        ),
      ),
    );
  }
}

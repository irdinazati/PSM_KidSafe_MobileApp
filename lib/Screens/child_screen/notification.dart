import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp3/Controller/OneSignalController.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../Models/track.dart';

Future<void> initiateNotifications(String userId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('drop_off_pick_up_schedules')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'Scheduled')
        .get();

    for (var doc in querySnapshot.docs) {
      DropOffPickUpSchedule schedule = DropOffPickUpSchedule.fromDoc(doc);
      DateTime pickUpTime = schedule.pickUpTime;
      DateTime notificationTime = pickUpTime.subtract(Duration(minutes: 5));

    // declare object for OneSignal notification
      OneSignalController onesignal = new OneSignalController();
      String title = "";
      String message = "";
      List<String> targetUser = [];

      // setup notification config for OneSignal
        title = "Pick-Up Reminder";
        message = "Reminder: Your pick-up time is approaching!";
        targetUser.add(userId);

        onesignal.SendNotification(title, message, targetUser);
    }
  } catch (e) {
    print('Error scheduling notifications: $e');
  }

  // Optional: Set up periodic checks if necessary
  Timer.periodic(Duration(minutes: 5), (Timer timer) async {
    await initiateNotifications(userId);
  });
}

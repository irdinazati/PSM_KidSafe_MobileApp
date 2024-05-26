import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationPage extends StatefulWidget {
  final String? currentUserId;

  const NotificationPage({Key? key, this.currentUserId}) : super(key: key);
  static const route = '/notification-screen';

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)?.settings.arguments as RemoteMessage?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notifications'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (message != null) ...[
              Text(message.notification?.title ?? 'No Title'),
              Text(message.notification?.body ?? 'No Body'),
              Text(message.data.toString()),
            ] else
              Text('No message received'),
          ],
        ),
      ),
    );
  }
}

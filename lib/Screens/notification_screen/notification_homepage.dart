import 'package:flutter/material.dart';

class NotificationHomePage extends StatefulWidget {
  final String? currentUserId;

  const NotificationHomePage({Key? key, this.currentUserId}) : super(key: key);

  @override
  State<NotificationHomePage> createState() => _NotificationHomePageState();
}

class _NotificationHomePageState extends State<NotificationHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Push Notifications'),
      ),
      body: const Center(child: Text('Home Page')),
    );
  }

}
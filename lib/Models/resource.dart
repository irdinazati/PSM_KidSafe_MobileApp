import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResourceItem extends StatelessWidget {
  final String title;
  final String description;

  const ResourceItem({
    Key? key,
    required this.title,
    required this.description, required Color backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        // You can customize this ListTile to display additional information
        // such as an icon or a button to view more details
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class ChildModel {
  String? id;
  final String childName;
  final String childGender;
  final int? childAge;
  final String childFullName;

  ChildModel({
    this.id,
    required this.childName,
    required this.childFullName,
    required this.childGender,
    required this.childAge,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childName': childName,
      'childFullName': childFullName,
      'childGender': childGender,
      'childAge': childAge,
    };
  }

  factory ChildModel.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    int? age;
    if (data?['childAge'] != null) {
      if (data!['childAge'] is String) {
        age = int.tryParse(data['childAge']);
      } else if (data['childAge'] is int) {
        age = data['childAge'];
      }
    }

    return ChildModel(
      id: doc.id, // Use doc.id to get the document ID
      childName: data?['childNickname'] ?? '',
      childFullName: data?['childFullName'] ?? '',
      childGender: data?['childGender'] ?? '',
      childAge: age ?? 0, // Assuming default age as 0 if not provided or conversion fails
    );
  }
}

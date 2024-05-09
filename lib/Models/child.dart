import 'package:cloud_firestore/cloud_firestore.dart';

class ChildModel {
  String? id;
  final String childName;
  final String childGender;
  final int childAge;
  final DateTime childDOB;

  var childFullName;

  ChildModel({
    this.id,
    required this.childName,
    required this.childFullName,
    required this.childGender,
    required this.childAge,
    required this.childDOB,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childName': childName,
      'childFullName': childFullName,
      'childGender': childGender,
      'childAge': childAge,
      'childDOB': childDOB,
    };
  }

  factory ChildModel.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return ChildModel(
      id: doc.id,
      childName: data?['childName'] ?? '',
      childFullName: data?['childFullName'] ?? '',
      childGender: data?['childGender'] ?? '',
      childAge: data?['childAge'] ?? 0, // Assuming default age as 0 if not provided
      childDOB: (data?['childDOB'] as Timestamp?)?.toDate() ?? DateTime.now(), // Convert Timestamp to DateTime
    );
  }
}

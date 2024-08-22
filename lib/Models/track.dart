import 'package:cloud_firestore/cloud_firestore.dart';

class DropOffPickUpSchedule {
  final String id;
  final String? userId;
  final String? childId;
  final String? childName; // Added childName field
  final DateTime dropOffTime;
  final DateTime pickUpTime;
  final String dropOffLocation; // Added dropOffLocation field
  final DateTime date;
  final String status;

  DropOffPickUpSchedule({
    required this.id,
    this.userId,
    this.childId,
    this.childName, // Added childName parameter
    required this.dropOffTime,
    required this.dropOffLocation, // Added dropOffLocation parameter
    required this.pickUpTime,
    required this.date,
    required this.status,
  });

  factory DropOffPickUpSchedule.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DropOffPickUpSchedule(
      id: doc.id,
      userId: data['userId'],
      childId: data['childId'],
      childName: data['childName'], // Handle childName field
      dropOffTime: (data['dropOffTime'] as Timestamp).toDate(),
      pickUpTime: (data['pickUpTime'] as Timestamp).toDate(),
      dropOffLocation: data['dropOffLocation'] ?? '', // Handle dropOffLocation field
      date: (data['date'] as Timestamp).toDate(),
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'childId': childId,
      'childName': childName, // Include childName field
      'dropOffTime': Timestamp.fromDate(dropOffTime),
      'pickUpTime': Timestamp.fromDate(pickUpTime),
      'dropOffLocation': dropOffLocation, // Include dropOffLocation field
      'date': Timestamp.fromDate(date),
      'status': status,
    };
  }
}

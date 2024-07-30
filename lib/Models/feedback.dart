import 'package:cloud_firestore/cloud_firestore.dart'; // Import this for Timestamp

class FeedbackModel {
  String? id;
  String? authorId;
  final double rating;
  final String comment;
  DateTime timestamp;

  FeedbackModel({
    this.id,
    this.authorId,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  // Convert FeedbackModel to a map suitable for Firestore
  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'rating': rating,
      'comment': comment,
      'timestamp': Timestamp.fromDate(timestamp), // Convert DateTime to Timestamp
    };
  }

  // Create a FeedbackModel instance from a Firestore map
  factory FeedbackModel.fromMap(Map<String, dynamic> map, String documentId) {
    return FeedbackModel(
      id: documentId,
      authorId: map['authorId'],
      rating: map['rating']?.toDouble() ?? 0.0,
      comment: map['comment'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(), // Convert Timestamp to DateTime
    );
  }

  // Format the DateTime object as a string
  String getFormattedDate() {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}';
  }
}

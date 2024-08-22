import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp3/Models/feedback.dart';
import 'package:fl_chart/fl_chart.dart';

class FeedbackListPage extends StatefulWidget {
  @override
  _FeedbackListPageState createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  List<FeedbackModel> feedbackList = [];
  List<FeedbackModel> allFeedback = [];
  double selectedRatingFilter = 0;
  Map<int, double> ratingDistribution = {};
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  Future<void> _loadFeedback({double? ratingFilter}) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('feedback')
          .get();

      List<FeedbackModel> feedback = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return FeedbackModel(
          id: doc.id,
          authorId: data['authorId'],
          rating: data['rating']?.toDouble() ?? 0.0,
          comment: data['comment'] ?? '',
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();

      // Calculate the distribution of ratings
      Map<int, double> distribution = {};
      for (var i = 1; i <= 5; i++) {
        int count = feedback.where((item) => item.rating == i.toDouble()).length;
        distribution[i] = feedback.isNotEmpty ? (count / feedback.length) * 100 : 0;
      }

      // Calculate average rating
      double totalRating = feedback.fold(0, (sum, item) => sum + item.rating);
      double avgRating = feedback.isNotEmpty ? totalRating / feedback.length : 0;

      setState(() {
        allFeedback = feedback;
        ratingDistribution = distribution;
        averageRating = avgRating;
        // Apply rating filter if provided
        feedbackList = ratingFilter != null && ratingFilter > 0
            ? feedback.where((item) => item.rating == ratingFilter).toList()
            : feedback;
        selectedRatingFilter = ratingFilter ?? 0;
      });
    } catch (error) {
      print('Error loading feedback: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: Text('All Feedback'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Pie Chart Widget
          Container(
            padding: EdgeInsets.all(16.0),
            height: 250, // Adjust height as needed
            child: PieChart(
              PieChartData(
                sections: ratingDistribution.entries.map((entry) {
                  final rating = entry.key;
                  final value = entry.value;
                  final color = _getColorForRating(rating);
                  return PieChartSectionData(
                    value: value,
                    color: color,
                    title: '$rating Stars\n${value.toStringAsFixed(1)}%',
                    radius: 50,
                    titleStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  );
                }).toList(),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          // Average Rating Statement
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Average Rating: ${averageRating.toStringAsFixed(1)} / 5 Stars',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          // Rating Filter Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) {
                final rating = index + 1;
                return ElevatedButton(
                  onPressed: () => _loadFeedback(ratingFilter: rating.toDouble()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedRatingFilter == rating
                        ? Colors.purple.shade300
                        : Colors.purple.shade100,
                  ),
                  child: Text('$rating'),
                );
              }),
            ),
          ),
          // Feedback Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0,
              ),
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                FeedbackModel feedback = feedbackList[index];
                return Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rating: ${feedback.rating}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Comment: ${feedback.comment}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Date: ${feedback.getFormattedDate()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to get color for each rating
  Color? _getColorForRating(int rating) {
    switch (rating) {
      case 1:
        return const Color.fromARGB(255, 250, 192, 192);
      case 2:
        return const Color.fromARGB(255, 222, 196, 156);
      case 3:
        return const Color.fromARGB(255, 231, 222, 142);
      case 4:
        return const Color.fromARGB(255, 176, 205, 143);
      case 5:
        return Colors.blue[100];
      default:
        return Colors.grey;
    }
  }
}

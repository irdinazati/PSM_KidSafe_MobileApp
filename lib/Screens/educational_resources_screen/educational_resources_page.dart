import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp3/Screens/educational_resources_screen/video_page.dart';
import 'package:http/http.dart' as http;

class SearchResult {
  final String title;
  final String snippet;
  final String videoId; // Include video ID in SearchResult

  SearchResult({required this.title, required this.snippet, required this.videoId});
}

class EducationalResourcesPage extends StatefulWidget {
  const EducationalResourcesPage({Key? key}) : super(key: key);

  @override
  _EducationalResourcesPageState createState() =>
      _EducationalResourcesPageState();
}

class _EducationalResourcesPageState extends State<EducationalResourcesPage> {
  TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  bool _isSearching = false;

  Future<void> _search(String query) async {
    if (_isSearching) {
      return; // Do not initiate another search if one is already in progress
    }
    setState(() {
      _isSearching = true; // Set isSearching to true to indicate a search is in progress
    });

    final apiKey = 'AIzaSyD2afoUjI7uL1Rivxikx11o4-jhFy0ilhg';
    final endpoint = 'https://www.googleapis.com/youtube/v3/search';
    final maxResults = 10; // Number of search results to fetch

    try {
      final response = await http.get(
        Uri.parse(
          '$endpoint'
              '?part=snippet'
              '&q=$query'
              '&key=$apiKey',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final searchResults = data['items'];
        setState(() {
          _searchResults = List<SearchResult>.from(searchResults.map((result) {
            return SearchResult(
              title: result['snippet']['title'],
              snippet: result['snippet']['description'],
              videoId: result['id']['videoId'], // Get video ID from the response
            );
          }));
        });
      } else {
        print('Failed to load search results. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isSearching = false; // Reset isSearching to false when search request completes
      });
    }
  }

  void _launchVideo(String videoId) {
    // Implement navigation to video page using the video ID
    // For example:
    Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPage(videoId: videoId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Educational Resources',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  onPressed: _isSearching ? null : () { // Disable button if search is in progress
                    _search(_searchController.text);
                  },
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _searchResults.isNotEmpty
                  ? ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        _searchResults[index].title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(_searchResults[index].snippet),
                      onTap: () {
                        _launchVideo(_searchResults[index].videoId); // Launch video when tapped
                      },
                    ),
                  );
                },
              )
                  : Center(
                child: _isSearching // Show loading indicator if search is in progress
                    ? CircularProgressIndicator()
                    : Text('No search results found'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

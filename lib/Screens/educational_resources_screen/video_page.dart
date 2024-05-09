import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoPage extends StatefulWidget {
  final String videoId;

  const VideoPage({Key? key, required this.videoId}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late String _channel;
  late String _description;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoMetadata();
  }

  Future<void> _fetchVideoMetadata() async {
    final apiKey = 'AIzaSyD2afoUjI7uL1Rivxikx11o4-jhFy0ilhg';
    final videoId = widget.videoId;

    try {
      final response = await http.get(
        Uri.parse(
          'https://www.googleapis.com/youtube/v3/videos?id=$videoId&part=snippet&key=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final snippet = data['items'][0]['snippet'];
        setState(() {
          _channel = snippet['channelTitle'];
          _description = snippet['description'];
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Page'),
        backgroundColor: Colors.purple[200],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _error
          ? Center(child: Text('Failed to load video metadata'))
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: widget.videoId,
              flags: YoutubePlayerFlags(
                autoPlay: true,
                mute: false,
              ),
            ),
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.purple[500],
            progressColors: ProgressBarColors(
              playedColor: Colors.purple[300],
              handleColor: Colors.purple[200],
            ),
            onReady: () {
              print('Player is ready');
            },
            onEnded: (metaData) {
              print('Video has ended');
            },
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Channel: ${_channel ?? 'Unknown'}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Text(
                  'Description: ${_description ?? 'No description available'}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

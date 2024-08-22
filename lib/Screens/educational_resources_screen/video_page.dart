import 'package:flutter/material.dart';
import 'package:fyp3/Screens/educational_resources_screen/educational_resources_page.dart';
import 'package:fyp3/Screens/vehicle_monitoring_screen/vehicle_monitoring_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../home_screen/homepage.dart';
import '../profile_screen/profile_page.dart';
import '../settings_screen/settings_page.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage(currentUserId: '')),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VehicleMonitoringPage(sensorName: '',)),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingPage(currentUserId: '')),
          );
          break;
      }
    });
  }

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
          leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black), // Use a color that fits your design
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
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
      // bottomNavigationBar: ConvexAppBar.badge(
      //   {0: '99+', 1: Icons.assistant_photo, 2: Colors.redAccent},
      //   items: [
      //     TabItem(icon: Icons.home, title: 'Home'),
      //     TabItem(icon: Icons.person, title: 'Profile'),
      //     TabItem(icon: Icons.car_crash_outlined, title: 'Vehicle Monitoring'),
      //   ],
      //   onTap: (int i) {
      //     switch (i) {
      //       case 0:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => HomePage()),
      //         );
      //         break;
      //       case 1:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => ProfilePage(currentUserId: '')),
      //         );
      //         break;
      //       case 2:
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => VehicleMonitoringPage(sensorName: '',)),
      //         );
      //         break;
      //     }
      //   },
      // ),
    );
  }
}

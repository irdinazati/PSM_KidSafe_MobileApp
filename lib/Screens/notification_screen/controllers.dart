import 'dart:convert';
import 'package:http/http.dart' as http;

class TelegramController {
  final String _botToken = '7315284800:AAGWlLnWcqzrrXaO54HOpjFvOdH5P2zKmQs';
  final String _chatId = '950416062';

  Future<void> sendTelegramNotification(String message) async {
    var url = 'https://api.telegram.org/bot$_botToken/sendMessage';
    var params = {
      'chat_id': _chatId,
      'text': message,
      'parse_mode': 'Markdown',
    };

    var response = await http.post(Uri.parse(url), body: params);

    if (response.statusCode == 200) {
      print("Telegram notification sent successfully.");
    } else {
      print("Failed to send Telegram notification. Status code: ${response.statusCode}");
    }
  }
}

class ThingSpeakController {
  static final String _readApiKey = 'GQXZ7HQWUIPKL9I8';
  static final String _channelId = '2554215';

  Future<Map<String, double>> readSensorData() async {
    var url = Uri.parse('https://api.thingspeak.com/channels/$_channelId/feeds/last.json?api_key=$_readApiKey');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      double temperature = double.parse(data['field1']); // Assuming field1 is temperature
      double motion = double.parse(data['field2']);      // Assuming field2 is motion
      return {
        'temperature': temperature,
        'motion': motion,
      };
    } else {
      print("Failed to read data from ThingSpeak. Status code: ${response.statusCode}");
      return {};
    }
  }
}

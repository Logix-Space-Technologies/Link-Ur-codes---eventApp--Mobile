import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackService {
  static Future<String> addFeedback(String feedback) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final Uri uri = Uri.parse('http://localhost:8085/api/feedback/addfeedbackuser');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'feedback': feedback}),
      );

      if (response.statusCode == 200) {
        return 'success';
      } else {
        return 'Failed to add feedback: ${response.body}';
      }
    } catch (error) {
      return 'Error adding feedback: $error';
    }
  }
}
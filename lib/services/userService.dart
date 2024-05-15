import 'dart:convert';
import 'package:event_app_mobile/api_constants.dart';
import 'package:event_app_mobile/models/publicEventModel.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class userApiService {
  Future<Map<String, dynamic>> loginApi(String email, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/users/loginuser');
    final response = await http.post(
      url,
      body: jsonEncode({
        'user_email': email,
        'user_password': password,
      }), // Encode the body to JSON
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'Success') {
        return {
          'success': true,
          'message': 'Login successful',
          'data': responseData['userData'],
          'token': responseData['token'],
        };
      } else if (responseData['status'] == 'Invalid Email ID') {
        return {
          'success': false,
          'message': 'Invalid Email ID',
        };
      } else if (responseData['status'] == 'Invalid Password') {
        return {
          'success': false,
          'message': 'Invalid Password',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to login User',
        };
      }
    } else {
      return {
        'success': false,
        'message': 'Failed to login User',
      };
    }
  }

  Future<dynamic> getPublicEvents(String token) async {
    var client = http.Client();
    var apiUrl = Uri.parse(
        "${ApiConstants.baseUrl}/api/events/view_user_public_events");
    try {
      var response = await client.post(
        apiUrl,
        headers: <String, String>{
          "Content-Type": "application/json",
          "token": token, // Authentication token usually goes in the headers
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Improved error message for debugging
        throw Exception('Failed to search. Status code: ${response
            .statusCode}. Response body: ${response.body}');
      }
    } finally {
      client.close();
    }
  }

  static Future<List<PublicEvents>> searchPublicEvents(String eventName,
      String token) async {
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/api/events/search-user_public-events');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
        body: jsonEncode({'event_public_name': eventName}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<PublicEvents> events = data.map((e) => PublicEvents.fromJson(e))
            .toList();
        return events;
      } else {
        throw Exception('Failed to load public events');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/users/view-user-profile'),
      headers: {
        'Content-Type': 'application/json',
        'token': token,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
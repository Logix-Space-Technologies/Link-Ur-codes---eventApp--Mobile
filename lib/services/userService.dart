import 'dart:convert';

import 'package:event_app_mobile/api_constants.dart';
import 'package:event_app_mobile/models/userModel.dart';
import 'package:http/http.dart'as http;

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
}

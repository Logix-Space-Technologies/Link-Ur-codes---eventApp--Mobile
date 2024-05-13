import 'package:event_app_mobile/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentApiService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/student/loginstudent');
    final response = await http.post(
      url,
      body: jsonEncode({
        'student_email': email,
        'student_password': password,
      }), // Encode the body to JSON
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'Success') {
        return {
          'success': true,
          'message': 'Login successful',
          'data': responseData['studentData'],
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
          'message': 'Failed to login student',
        };
      }
    } else {
      return {
        'success': false,
        'message': 'Failed to login student',
      };
    }
  }
}

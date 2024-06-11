import 'package:http/http.dart' as http;
import 'dart:convert';

import '../api_constants.dart';

class CollegeLoginService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/college/departmentLogin');
    final response = await http.post(
      url,
      body: jsonEncode({
        'faculty_email': email,
        'faculty_password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        return {
          'success': true,
          'message': 'Login successful',
          'data': responseData['facultyData'],
          'token': responseData['collegetoken'],
        };
      } else if (responseData['status'] == 'incorrect email') {
        return {
          'success': false,
          'message': 'Faculty not found',
        };
      } else if (responseData['status'] == 'incorrect password') {
        return {
          'success': false,
          'message': 'Incorrect password',
        };
      } else {
        return {
          'success': false,
          'message': responseData['error'] ?? 'Login failed',
        };
      }
    } else if (response.statusCode == 404) {
      return {
        'success': false,
        'message': 'Endpoint not found',
      };
    } else if (response.statusCode == 500) {
      return {
        'success': false,
        'message': 'Server error',
      };
    } else {
      return {
        'success': false,
        'message': 'Failed to login faculty',
      };
    }
  }

  Future<Map<String, dynamic>> getFacultyProfile(int facultyId, String collegeToken) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/college/viewFacultyProfile'),
        headers: {
          'Content-Type': 'application/json',
          'collegetoken': collegeToken,
        },
        body: jsonEncode({'id': facultyId}),
      );

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData; // Assuming responseData is the faculty details
      } else {
        throw Exception('Failed to load faculty profile');
      }
    } catch (e) {
      throw Exception('Failed to fetch faculty profile: $e');
    }
  }

  Future<void> updateFacultyProfile(int facultyId, String facultyName, String facultyEmail, String facultyPhone, String collegeToken) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/college/update_faculty'),
        headers: {
          'Content-Type': 'application/json',
          'collegetoken': collegeToken,
        },
        body: json.encode({
          'id': facultyId,
          'faculty_name': facultyName,
          'faculty_email': facultyEmail,
          'faculty_phone': facultyPhone,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update faculty profile');
      }

      final responseData = json.decode(response.body);
      if (responseData['status'] != 'success') {
        throw Exception(responseData['message']);
      }
    } catch (e) {
      throw Exception('Failed to update faculty profile: $e');
    }
  }
}

import 'package:event_app_mobile/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CollegeLoginService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}api/college/collegeLogin');
    final response = await http.post(
      url,
      body: jsonEncode({
        'college_email': email,
        'college_password': password,
      }), // Encode the body to JSON
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        return {
          'success': true,
          'message': 'Login successful',
          'data': responseData['collegedata'],
          'token': responseData['collegetoken'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['status'],
        };
      }
    } else if (response.statusCode == 404) {
      return {
        'success': false,
        'message': 'College not found',
      };
    } else if (response.statusCode == 500) {
      return {
        'success': false,
        'message': 'Error retrieving college data',
      };
    } else {
      return {
        'success': false,
        'message': 'Failed to login college',
      };
    }
  }

  Future<Map<String, dynamic>> getCollegeDetails(String collegeToken) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/college/Viewcollegedetail'),
        headers: {
          'Content-Type': 'application/json',
          'collegetoken': collegeToken,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          return responseData['collegedata'];
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Failed to load college details');
      }
    } catch (e) {
      throw Exception('Failed to fetch college details: $e');
    }
  }
}
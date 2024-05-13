import 'package:event_app_mobile/models/studentModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentApiService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('http://localhost:8085/api/student/loginstudent');
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

  Future<Map<String, dynamic>> forgotpassword(String email) async {
    final url = Uri.parse('http://localhost:8085/api/student/forgotpassword');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({'student_email': email}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        // Request was successful, parse and return the response body
        return jsonDecode(response.body);
      } else {
        // Request failed with a non-200 status code
        print('Request failed with status: ${response.statusCode}');
        return {'success': false, 'message': 'Failed to reset password'};
      }
    } catch (error) {
      // Request failed due to an error (e.g., network error)
      print('Request failed with error: $error');
      return {'success': false, 'message': 'Failed to reset password'};
    }
  }


  Future<List<Student>> getstud(String student_id,token) async {
    print(token);
    var client = http.Client();
    var apiUri = Uri.parse("http://localhost:8085/api/student/viewstud1");

    try {
      var response = await client.post(
        apiUri,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "token":token
        },
        body: jsonEncode(<String, String>{
          "student_id": student_id

        }),
      );

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the response body into a list of Student objects
        List<dynamic> responseBody = jsonDecode(response.body);
        List<Student> students = responseBody.map((json) => Student.fromJson(json)).toList();

        return students;
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occur during the HTTP request
      print('Error: $e');
      throw Exception('Failed to load students');
    } finally {
      // Close the client to free up resources
      client.close();
    }
  }

    }

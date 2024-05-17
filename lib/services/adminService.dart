import 'dart:convert';
import 'package:event_app_mobile/api_constants.dart';
import 'package:event_app_mobile/models/adminCollege.dart';
import 'package:event_app_mobile/models/adminModel.dart';
import 'package:event_app_mobile/models/publicEventModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class AdminService {

  static const String baseUrl = '${ApiConstants.baseUrl}/api/admin'; // Update with your API base URL
  static Future<Map<String, dynamic>> loginAdmin(String username, String password) async {
    final url = Uri.parse('$baseUrl/loginadmin');
    final admin = Admin(adminUsername: username, adminPassword: password);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(admin.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to login admin');
    }
  }

  Future<dynamic> getPublicEvents(String token) async {
    var client = http.Client();
    var apiUrl = Uri.parse("${ApiConstants.baseUrl}/api/events/view_public_events");
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
        throw Exception('Failed to search. Status code: ${response.statusCode}. Response body: ${response.body}');
      }
    } finally {
      client.close();
    }
  }

  Future<dynamic> getPrivateEvents(String token) async {
    var client = http.Client();
    var apiUrl = Uri.parse("${ApiConstants.baseUrl}/api/events/view_private_events");
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
        throw Exception('Failed to search. Status code: ${response.statusCode}. Response body: ${response.body}');
      }
    } finally {
      client.close();
    }
  }

  Future<dynamic> getColleges(String token) async {
    var client = http.Client();
    var apiUrl = Uri.parse("${ApiConstants.baseUrl}/api/college/Viewcollege");
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
        throw Exception('Failed to search. Status code: ${response.statusCode}. Response body: ${response.body}');
      }
    } finally {
      client.close();
    }
  }

  Future<dynamic> getUsers(String token) async {
    var client = http.Client();
    var apiUrl = Uri.parse("${ApiConstants.baseUrl}/api/users/viewusers");
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
        throw Exception('Failed to search. Status code: ${response.statusCode}. Response body: ${response.body}');
      }
    } finally {
      client.close();
    }
  }

  // static Future<List<Colleges>> searchColleges(String collegeName, String token) async {
  //   final Uri uri = Uri.parse('${ApiConstants.baseUrl}/api/college/searchCollege');
  //   try {
  //     final response = await http.post(
  //       uri,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'token': token,
  //       },
  //       body: jsonEncode({'term': collegeName}),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(response.body);
  //       List<Colleges> colleges = data.map((e) => Colleges.fromJson(e)).toList();
  //       return colleges;
  //     } else {
  //       throw Exception('Failed to load colleges');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to connect to the server: $e');
  //   }
  // }


  static Future<List<PublicEvents>> searchPublicEvents(String eventName, String token) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}/api/events/search-public-events');
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
        List<PublicEvents> events = data.map((e) => PublicEvents.fromJson(e)).toList();
        return events;
      } else {
        throw Exception('Failed to load public events');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}



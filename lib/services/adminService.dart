import 'dart:convert';
import 'package:event_app_mobile/models/adminModel.dart';
import 'package:event_app_mobile/models/publicEventModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class AdminService {
  static const String baseUrl = 'http://192.168.1.8:8085/api/admin'; // Update with your API base URL

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

  // Future<List<PublicEvents>> getPublicEvents() async
  // {
  //   var client = http.Client();
  //   var apiUrl=Uri.parse("http://192.168.1.8:8085/api/events/view_public_events");
  //   var response=await client.get(apiUrl);
  //   if(response.statusCode==200)
  //   {
  //     return publicEventsFromJson(response.body);
  //   }
  //   else
  //   {
  //     return [];
  //   }
  // }

  Future<dynamic> getPublicEvents(String token) async {
    var client = http.Client();
    var apiUrl = Uri.parse("http://192.168.1.8:8085/api/events/view_public_events");
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
    var apiUrl = Uri.parse("http://192.168.1.8:8085/api/events/view_private_events");
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
}


  Future<dynamic> getColleges(String token) async {
    var client = http.Client();
    var apiUrl = Uri.parse("http://192.168.1.8:8085/api/college/Viewcollege");
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
    var apiUrl = Uri.parse("http://192.168.1.8:8085/api/users/viewusers");
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
}

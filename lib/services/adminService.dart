import 'dart:convert';
import 'package:event_app_mobile/models/adminModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class AdminService {
  static const String baseUrl = 'http://localhost:8085/api/admin'; // Update with your API base URL

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
}

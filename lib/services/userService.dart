import 'dart:convert';

import 'package:http/http.dart'as http;

class userApiService{
  Future<dynamic> loginApi(String email, String password) async {
    var url = Uri.parse("http://localhost:8085/api/users/loginuser");
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, String>{
          "user_email": email,
          "user_password": password,
        }),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 'Success') {
          return responseData;
        } else {
          throw Exception(responseData['status']);
        }
      } else {
        throw Exception("Failed to send data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
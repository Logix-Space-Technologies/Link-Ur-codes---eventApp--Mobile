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
  Future<dynamic> signupData(String name,email, pass , contactnoController,qual, skils) async {
    try {
      var client = http.Client();
      var apiUrl = Uri.parse("http://localhost:8085/api/users/signup");
      var response = await client.post(
        apiUrl,
        headers: <String, String>{
          "Content-Type": "application/json;charset=UTF-8"
        },
        body: jsonEncode(<String, String>{
          "user_name": name,
          "user_email": email,
          "user_password": pass,
          "user_contact_no":contactnoController,
          "user_qualification":qual,
          "user_skills":skils
        }),
      );

      if (response.statusCode == 400) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to send data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}

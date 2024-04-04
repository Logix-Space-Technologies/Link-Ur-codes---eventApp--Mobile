import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApiService {
  Future<dynamic> sendData(String name, String email, String pass) async {
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
          "user_password": pass
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to send data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}

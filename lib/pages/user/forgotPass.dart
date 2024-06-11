import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../api_constants.dart';

class ForgotPassPage extends StatefulWidget {
  @override
  _ForgotPassPageState createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isVerificationStage = false;

  Future<void> _requestPasswordReset() async {
    final email = _emailController.text.trim();

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/users/forgotpassword'),
      body: jsonEncode({'user_email': email}),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = json.decode(response.body);

    if (responseData['status'] == 'success') {
      setState(() {
        _isVerificationStage = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message']), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['error']), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _updatePassword() async {
    final email = _emailController.text.trim();
    final verificationCode = _verificationCodeController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/users/updatePassword'),
      body: jsonEncode({
        'user_email': email,
        'verification_code': verificationCode,
        'user_password': newPassword,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = json.decode(response.body);

    if (responseData['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message']), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message']), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Forgot Password',
          style: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Color(0xFFFFFFFF)),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: Icon(Icons.email),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20.0),
            if (_isVerificationStage) ...[
              TextFormField(
                controller: _verificationCodeController,
                decoration: InputDecoration(
                  labelText: 'Verification Code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(Icons.verified),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
            ],
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _isVerificationStage ? _updatePassword : _requestPasswordReset,
              child: Text(
                _isVerificationStage ? 'Update Password' : 'Request Password Reset',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _verificationCodeController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}
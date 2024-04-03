import 'package:event_app_mobile/pages/admin/adminloginSuccess.dart';
import 'package:event_app_mobile/services/adminService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _loginAdmin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response = await AdminService.loginAdmin(username, password);
      if (response['status'] == 'success') {
        final token = response['admintoken'];

        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('admintoken', token);
        print("admintoken:"+token);

        // Navigate to admin dashboard or any desired page
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SuccessPage()));
      } else {
        // Display error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(response['status']),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to login admin. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _loginAdmin,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

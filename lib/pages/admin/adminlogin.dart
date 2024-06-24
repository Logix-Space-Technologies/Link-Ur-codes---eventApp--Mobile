import 'package:event_app_mobile/pages/admin/adminHome.dart';
import 'package:event_app_mobile/services/adminService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLogin extends StatefulWidget {
  @override
  createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  void _loginAdmin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response = await AdminService.loginAdmin(username, password);
      if (response['status'] == 'success') {
        final admintoken = response['admintoken'];
        final adminId = response['adminData']['admin_id']; // Get admin ID from response

        if (admintoken != null && adminId != null) {
          // Save token and admin ID to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('admintoken', admintoken);
          prefs.setInt('adminId', adminId); // Save admin ID as int

          print("admintoken: $admintoken");
          print("adminId: $adminId");

          // Navigate to admin dashboard or any desired page
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome()));
        } else {
          _showErrorDialog('Invalid response from server.');
        }
      } else {
        _showErrorDialog(response['status']);
      }
    } catch (error) {
      print('Error: $error');
      _showErrorDialog('Failed to login admin. Please try again later.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1D1E33),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Color(0xff6aa4a1)),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous screen
          },
        ), // You can customize the AppBar further if needed
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1D1E33), Color(0xff6aa4a1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                  decoration: BoxDecoration(
                    color: Color(0xffb5d7d5),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Admin Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1E33),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          prefixIcon: Icon(Icons.person, color: Color(0xff6aa4a1)),
                        ),
                        style: TextStyle(color: Color(0xFF1D1E33)),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure, // Use _isObscure to toggle visibility
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          prefixIcon: Icon(Icons.lock, color: Color(0xff6aa4a1)),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off, color: Color(0xff6aa4a1)),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure; // Toggle visibility on button press
                              });
                            },
                          ),
                        ),
                        style: TextStyle(color: Color(0xFF1D1E33)),
                      ),
                      SizedBox(height: 10.0),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _loginAdmin,
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1D1E33),
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

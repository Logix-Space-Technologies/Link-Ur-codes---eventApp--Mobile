import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/collegeService.dart';
import 'collegeHomePage.dart';

class CollegeLogin extends StatefulWidget {
  @override
  _CollegeLoginState createState() => _CollegeLoginState();
}

class _CollegeLoginState extends State<CollegeLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  final CollegeLoginService _collegeLoginService = CollegeLoginService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 5,
            ),
            Text('College Login',style: TextStyle(color:  Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
          ],
        ),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon:Icon(Icons.arrow_back_ios_new,color:  Color(0xFFFFFFFF),)),
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
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure; // Toggle visibility on button press
                    });
                  },
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _login,
                child: Text(
                  'Login',
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
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final response = await _collegeLoginService.login(email, password);

    if (response['success']) {
      final data = response['data'];
      final token = response['token'];

      // Store college_id and token in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('college_id', data['college_id']);
      prefs.setString('college_token', token);

      print('College ID: ${data['college_id']}');
      print('College Token: $token');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>CollegeMenu()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UserRegisterPage extends StatefulWidget {
  @override
  _UserRegisterPageState createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _signUp() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String contactNo = _contactNoController.text.trim();
    final String qualification = _qualificationController.text.trim();
    final String skills = _skillsController.text.trim();

    final response = await http.post(
      Uri.parse('http://localhost:8085/api/users/signup'),
      body: jsonEncode({
        'user_name': name,
        'user_email': email,
        'user_password': password,
        'user_contact_no': contactNo,
        'user_qualification': qualification,
        'user_skills': skills,
        // Convert image to base64 string before sending
        'user_image': _image != null ? base64Encode(_image!.readAsBytesSync()) : null,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _contactNoController,
              decoration: InputDecoration(labelText: 'Contact Number'),
            ),
            TextField(
              controller: _qualificationController,
              decoration: InputDecoration(labelText: 'Qualification'),
            ),
            TextField(
              controller: _skillsController,
              decoration: InputDecoration(labelText: 'Skills'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 16),
            _image != null
                ? Image.asset(_image!.path) // Display picked image
                : Container(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

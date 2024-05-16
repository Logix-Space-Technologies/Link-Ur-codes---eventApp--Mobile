import 'dart:io';
import 'package:event_app_mobile/pages/user/userlogin.dart';
import 'package:event_app_mobile/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserRegisterPage extends StatefulWidget {
  @override
  _UserRegisterPageState createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _contactController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _skillsController = TextEditingController();
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        final apiService = userApiService(); // Correctly instantiate the service
        final response = await apiService.signup(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          _contactController.text,
          _qualificationController.text,
          _skillsController.text,
          _imageFile!,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserLogin()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact No'),
                validator: (value) => value!.isEmpty ? 'Please enter your contact number' : null,
              ),
              TextFormField(
                controller: _qualificationController,
                decoration: InputDecoration(labelText: 'Qualification'),
                validator: (value) => value!.isEmpty ? 'Please enter your qualification' : null,
              ),
              TextFormField(
                controller: _skillsController,
                decoration: InputDecoration(labelText: 'Skills'),
                validator: (value) => value!.isEmpty ? 'Please enter your skills' : null,
              ),
              SizedBox(height: 10),
              _imageFile == null
                  ? Text('No image selected.')
                  : Image.file(_imageFile!),
              TextButton(
                onPressed: _pickImage,
                child: Text('Select Image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                child: Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

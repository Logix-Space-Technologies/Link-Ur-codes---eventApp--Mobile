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
  bool _isObscure = true;


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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon:Icon(Icons.arrow_back_ios_new_outlined,color:Color(0xFF1D1E33),)),
        title: Text(
          'Create An Account',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1E33),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.0),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor:  Color(0xFF6AA4A1),
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : null,
                    child: _imageFile == null
                        ? Icon(
                      Icons.camera_alt,
                      color:  Color(0xFF1D1E33),
                      size: 50,
                    )
                        : null,
                  ),
                ),
                SizedBox(height: 30.0),
                _buildTextField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.person,
                ),
                SizedBox(height: 20.0),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
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
                    prefixIcon: Icon(Icons.lock,color: Color(0xff6aa4a1)),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off,color: Color(0xff6aa4a1)),
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
                _buildTextField(
                  controller: _contactController,
                  label: 'Contact No',
                  icon: Icons.phone,
                ),
                SizedBox(height: 20.0),
                _buildTextField(
                  controller: _qualificationController,
                  label: 'Qualification',
                  icon: Icons.school,
                ),
                SizedBox(height: 20.0),
                _buildTextField(
                  controller: _skillsController,
                  label: 'Skills',
                  icon: Icons.work,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _signup,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1D1E33),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => UserLogin()));
                  },
                  child: Text(
                    'Already have an account? Sign in',
                    style: TextStyle(color: Color(0xFF1D1E33),fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF6AA4A1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      obscureText: obscureText,
      validator: (value) => value!.isEmpty ? 'Please enter your $label' : null,
    );
  }
}

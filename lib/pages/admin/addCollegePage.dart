import 'package:event_app_mobile/services/adminService.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // For File
import 'package:image_picker/image_picker.dart'; // For ImagePicker
import 'package:jwt_decoder/jwt_decoder.dart';

class AddCollegeScreen extends StatefulWidget {
  final String token;

  AddCollegeScreen({required this.token});

  @override
  _AddCollegeScreenState createState() => _AddCollegeScreenState();
}

class _AddCollegeScreenState extends State<AddCollegeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _collegeNameController = TextEditingController();
  final _collegeEmailController = TextEditingController();
  final _collegePhoneController = TextEditingController();
  final _collegeWebsiteController = TextEditingController();
  File? _image;
  final _picker = ImagePicker();
  bool _loading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _image != null) {
      setState(() {
        _loading = true;
      });

      try {
        // Decode the token to get the adminId
        Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
        String adminId = decodedToken['admin_id'].toString();

        Map<String, String> data = {
          'college_name': _collegeNameController.text,
          'college_email': _collegeEmailController.text,
          'college_phone': _collegePhoneController.text,
          'college_website': _collegeWebsiteController.text,
          'college_addedby': adminId,
          'college_updatedby': adminId,
        };

        var response = await AdminService().addCollege(data, _image!, widget.token);

        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('College added successfully')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'])));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add college: ${e.toString()}')));
      } finally {
        setState(() {
          _loading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields and select an image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add College')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _collegeNameController,
                decoration: InputDecoration(labelText: 'College Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter college name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _collegeEmailController,
                decoration: InputDecoration(labelText: 'College Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter college email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _collegePhoneController,
                decoration: InputDecoration(labelText: 'College Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter college phone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _collegeWebsiteController,
                decoration: InputDecoration(labelText: 'College Website'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter college website';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _image == null
                  ? Text('No image selected.')
                  : Image.file(_image!),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select Image'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Add College'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class AddPrivateEvent extends StatefulWidget {
  const AddPrivateEvent({super.key});

  @override
  State<AddPrivateEvent> createState() => _AddPrivateEventState();
}

class _AddPrivateEventState extends State<AddPrivateEvent> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    var uri = Uri.parse("https://your-backend-api-url/upload"); // Replace with your backend URL
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'file', // This field should match the name expected by the server
        _image!.path,
        filename: basename(_image!.path),
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      // Handle successful upload
      print('Image uploaded successfully!');
    } else {
      // Handle failure
      print('Image upload failed: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Add Private Event')),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              if (_image != null)
                Image.file(_image!),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image from Gallery'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Upload Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

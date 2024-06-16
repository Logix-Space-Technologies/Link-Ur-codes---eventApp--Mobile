import 'dart:io';
import 'package:event_app_mobile/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class AddPublicEventScreen extends StatefulWidget {
  @override
  _AddPublicEventScreenState createState() => _AddPublicEventScreenState();
}

class _AddPublicEventScreenState extends State<AddPublicEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _eventData = {};
  File? _image;
  File? _pdf;
  final ImagePicker _picker = ImagePicker();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pdf = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime)
      setState(() {
        _selectedTime = pickedTime;
      });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();

      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload an image')),
        );
        return;
      }

      if (_pdf == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload a PDF')),
        );
        return;
      }

      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select both a date and a time')),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('admintoken') ?? '';

      if (token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Admin token not found')),
        );
        return;
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}/api/events/add_public_events');
      final request = http.MultipartRequest('POST', uri);

      request.headers['token'] = token;

      // Decode token to get the username
      final decodedToken = _decodeToken(token);
      final addedBy = decodedToken['adminUsername'];

      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final formattedTime = _selectedTime!.format(context);

      request.fields.addAll({
        'event_public_name': _eventData['event_public_name']!,
        'event_public_amount': _eventData['event_public_amount']!,
        'event_public_description': _eventData['event_public_description']!,
        'event_public_date': formattedDate,
        'event_public_time': formattedTime,
        'event_venue': _eventData['event_venue']!,
        'event_addedby': addedBy,
        'event_updatedby': addedBy,
      });

      final mimeTypeData = lookupMimeType(_image!.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final mimeTypeDataPdf = lookupMimeType(_pdf!.path, headerBytes: [0x25, 0x50])?.split('/');

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _image!.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      ));

      request.files.add(await http.MultipartFile.fromPath(
        'pdf',
        _pdf!.path,
        contentType: MediaType(mimeTypeDataPdf![0], mimeTypeDataPdf[1]),
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event added successfully!')),
        );
      } else {
        final respStr = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add event: $respStr')),
        );
      }
    }
  }

  Map<String, dynamic> _decodeToken(String token) {
    return Jwt.parseJwt(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Public Event'),
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Name'),
                onSaved: (value) {
                  _eventData['event_public_name'] = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Amount'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _eventData['event_public_amount'] = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Description'),
                onSaved: (value) {
                  _eventData['event_public_description'] = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event description';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Event Date'),
                      readOnly: true,
                      onTap: _pickDate,
                      controller: TextEditingController(
                        text: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please pick a date';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Event Time'),
                      readOnly: true,
                      onTap: _pickTime,
                      controller: TextEditingController(
                        text: _selectedTime != null ? _selectedTime!.format(context) : '',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please pick a time';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: _pickTime,
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Venue'),
                onSaved: (value) {
                  _eventData['event_venue'] = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event venue';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select Image'),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: _pickPdf,
                child: Text('Select PDF'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

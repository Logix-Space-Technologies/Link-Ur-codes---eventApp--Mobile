import 'dart:convert';
import 'dart:io';

import 'package:event_app_mobile/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Added for date formatting

class AddPublicEvent extends StatefulWidget {
  @override
  _AddPublicEventState createState() => _AddPublicEventState();
}

class _AddPublicEventState extends State<AddPublicEvent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventAmountController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();
  final TextEditingController _eventVenueController = TextEditingController();
  final TextEditingController _eventDurationController = TextEditingController();
  final TextEditingController _eventOnlineController = TextEditingController();
  final TextEditingController _eventOfflineController = TextEditingController();
  final TextEditingController _eventRecordedController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController(); // Controller for event date

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _loading = false;
  File? _selectedImage;
  File? _selectedPdf;

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventAmountController.dispose();
    _eventDescriptionController.dispose();
    _eventVenueController.dispose();
    _eventDurationController.dispose();
    _eventOnlineController.dispose();
    _eventOfflineController.dispose();
    _eventRecordedController.dispose();
    _eventDateController.dispose(); // Dispose of event date controller
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _eventDateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate); // Initialize event date text field
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _eventDateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate); // Update event date text field
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedPdf = File(result.files.single.path!);
      });
      debugPrint('PDF selected: ${_selectedPdf!.path}');
    } else {
      debugPrint('No PDF selected');
    }
  }

  Future<int?> _getAdminId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('adminid');
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null || _selectedPdf == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image or PDF file not selected')));
        return;
      }

      setState(() {
        _loading = true;
      });

      final int? adminId = await _getAdminId();
      if (adminId == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Admin ID not found')));
        setState(() {
          _loading = false;
        });
        return;
      }

      try {
        final uri = Uri.parse('${ApiConstants.baseUrl}/api/events/add_public_events');
        final request = http.MultipartRequest('POST', uri)
          ..fields['event_public_name'] = _eventNameController.text
          ..fields['event_public_amount'] = _eventAmountController.text
          ..fields['event_public_description'] = _eventDescriptionController.text
          ..fields['event_public_date'] = _selectedDate.toIso8601String()
          ..fields['event_public_time'] = "${_selectedTime.hour}:${_selectedTime.minute}"
          ..fields['event_public_duration'] = _eventDurationController.text
          ..fields['event_public_online'] = _eventOnlineController.text
          ..fields['event_public_offline'] = _eventOfflineController.text
          ..fields['event_public_recorded'] = _eventRecordedController.text
          ..fields['event_venue'] = _eventVenueController.text
          ..fields['event_addedby'] = adminId.toString()
          ..headers['token'] = 'admintoken';

        request.files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));
        request.files.add(await http.MultipartFile.fromPath('pdf', _selectedPdf!.path));  // Changed field name to 'pdf'

        final response = await request.send();

        if (response.statusCode == 200) {
          final respStr = await response.stream.bytesToString();
          final respJson = jsonDecode(respStr);
          if (respJson['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event added successfully')));
            // Handle successful response
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add event')));
            // Handle error in response
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to connect to server')));
          // Handle non-200 status code
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Public Event'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _eventNameController,
                  decoration: InputDecoration(labelText: 'Event Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter event name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _eventAmountController,
                  decoration: InputDecoration(labelText: 'Event Amount'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter event amount';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _eventDescriptionController,
                  decoration: InputDecoration(labelText: 'Event Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter event description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _eventDurationController,
                  decoration: InputDecoration(labelText: 'Event Duration'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter event duration';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _eventOnlineController,
                  decoration: InputDecoration(labelText: 'Online Duration'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter online duration';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _eventOfflineController,
                  decoration: InputDecoration(labelText: 'Offline Duration'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter offline duration';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _eventRecordedController,
                  decoration: InputDecoration(labelText: 'Recorded Duration'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter recorded duration';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _eventVenueController,
                  decoration: InputDecoration(labelText: 'Event Venue'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter event venue';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _eventDateController,
                        decoration: InputDecoration(labelText: 'Event Date'),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter event date';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select date'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Event Time: ${_selectedTime.format(context)}"),
                    ElevatedButton(
                      onPressed: () => _selectTime(context),
                      child: Text('Select time'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text("Pick Image"),
                    ),
                    SizedBox(width: 10),
                    Text(_selectedImage == null ? "No image chosen" : "Image selected"),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickPdf,
                      child: Text("Pick PDF"),
                    ),
                    SizedBox(width: 10),
                    Text(_selectedPdf == null ? "No PDF chosen" : "PDF selected"),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Add Event'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

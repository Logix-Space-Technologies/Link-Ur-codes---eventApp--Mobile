import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';

class StudentDetailsPage extends StatefulWidget {
  const StudentDetailsPage({Key? key}) : super(key: key);

  @override
  _StudentDetailsPageState createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _rollNoController;
  late TextEditingController _admNoController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNoController;
  late TextEditingController _eventIdController;
  late TextEditingController _collegeIdController;
  int _selectedOption = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _rollNoController = TextEditingController();
    _admNoController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNoController = TextEditingController();
    _eventIdController = TextEditingController();
    _collegeIdController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rollNoController.dispose();
    _admNoController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _eventIdController.dispose();
    _collegeIdController.dispose();
    super.dispose();
  }

  Future<void> _uploadStudents() async {
    // Implement your upload logic here
  }

  Future<void> _downloadSampleExcel() async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];
      sheet.appendRow([
        'student_name',
        'student_rollno',
        'student_admno',
        'student_email',
        'student_phone_no',
        'event_id',
        'student_college_id',
      ]);
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/sample.xlsx';
      final file = File(filePath);
      await file.writeAsBytes((await excel.encode())!);
      OpenFile.open(filePath);
    } catch (e) {
      print('Error downloading sample Excel: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RadioListTile<int>(
              title: Text('Upload Excel'),
              value: 0,
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value!;
                });
              },
            ),
            RadioListTile<int>(
              title: Text('Manual Entry'),
              value: 1,
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value!;
                });
              },
            ),
            SizedBox(height: 20.0),
            if (_selectedOption == 0) ...[
              ElevatedButton(
                onPressed: _downloadSampleExcel,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: Text(
                  'Download Sample Excel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),
              // File upload section
              // Add logic to upload .csv or .xlsx files
              // Use a package like file_picker to pick files
              // https://pub.dev/packages/file_picker
              // Use a file upload button
              // Implement your upload logic
              // Display selected file name if any
              ElevatedButton(
                onPressed: _uploadStudents,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: Text(
                  'Upload',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            SizedBox(height: 20.0),
            if (_selectedOption == 1) ...[
              // TextFields for manual entry
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _rollNoController,
                decoration: InputDecoration(labelText: 'Roll No'),
              ),
              TextField(
                controller: _admNoController,
                decoration: InputDecoration(labelText: 'Admission No'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _phoneNoController,
                decoration: InputDecoration(labelText: 'Phone No'),
              ),
              TextField(
                controller: _eventIdController,
                decoration: InputDecoration(labelText: 'Event ID'),
              ),
              TextField(
                controller: _collegeIdController,
                decoration: InputDecoration(labelText: 'College ID'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _uploadStudents,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

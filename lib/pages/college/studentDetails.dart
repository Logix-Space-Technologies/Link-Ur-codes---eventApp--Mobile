import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_selector/file_selector.dart';

import '../../api_constants.dart';

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
  int _selectedPage = 0;
  PageController _pageController = PageController();
  File? _selectedFile;
  late String _collegeToken;

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
    _loadCollegeToken();
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
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _addStudent() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final int studentCollegeIdInt = prefs.getInt('college_id') ?? 0; // Default value is 0
  final String studentCollegeId = studentCollegeIdInt.toString();
  final String collegeToken = prefs.getString('college_token') ?? '';
  final String apiUrl = '${ApiConstants.baseUrl}/api/college/student/add';
  Map<String, dynamic> requestBody = {
  'student_name': _nameController.text,
  'student_rollno': _rollNoController.text,
  'student_admno': _admNoController.text,
  'student_email': _emailController.text,
  'student_phone_no': _phoneNoController.text,
  'event_id': _eventIdController.text,
  'student_college_id': studentCollegeId,
  };

  // Prepare the request headers
  Map<String, String> headers = {
  'Content-Type': 'application/json',
  'collegetoken': collegeToken,
  };

  // Make the API request
  final response = await http.post(
  Uri.parse(apiUrl),
  headers: headers,
  body: jsonEncode(requestBody),
  );

  // Check if the request was successful
  if (response.statusCode == 200) {
  // Show success message using SnackBar
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  content: Text('Student added successfully!'),
  backgroundColor: Colors.green,
  ));
  } else {
  // Show failure message using SnackBar
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  content: Text('Failed to add student. Please try again later.'),
  backgroundColor: Colors.red,
  ));
  }
  }

  Future<void> _loadCollegeToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('college_token');
    if (token != null) {
      setState(() {
        _collegeToken = token;
      });
    } else {
      // Handle the case when the token is not found in SharedPreferences
      print('College token not found in SharedPreferences.');
    }
  }


  Future<void> _pickFile() async {
    final typeGroup = XTypeGroup(label: 'excel', extensions: ['xlsx']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file != null) {
      setState(() {
        _selectedFile = File(file.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No file selected.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadStudents(File file, String collegeToken) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/college/studentupload');
      final request = http.MultipartRequest('POST', url)
        ..headers['collegetoken'] = '$collegeToken' // Add the college token as a header
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File uploaded successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload file. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error uploading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading file. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  Widget _buildUploadExcelSection(String collegeToken) {
    return GestureDetector(
      onTap: () async {
        await _pickFile();
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
            //border: Border.all(color: Colors.black),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.upload_file, size: 50.0, color: Colors.black),
              SizedBox(height: 10.0),
              Text(
                _selectedFile != null
                    ? 'Selected File: ${_selectedFile!
                    .path
                    .split('/')
                    .last}'
                    : 'Tap to select a file',
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              if (_selectedFile != null) ...[
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedFile != null) {
                      _uploadStudents(_selectedFile!, collegeToken);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  child: Text(
                    'Upload File',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              SizedBox(height: 20.0),
              TextButton(
                onPressed: _downloadSampleExcel,
                child: Text(
                  'Download Sample Excel',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManualEntrySection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            SizedBox(height: 20.0),
            ElevatedButton(
                onPressed: _addStudent,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
              child: Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _collegeToken.isEmpty // Check if _collegeToken is empty (not initialized)
          ? Center(
        child: CircularProgressIndicator(), // Show a loading indicator
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedPage = 0;
                    });
                    _pageController.animateToPage(0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        _selectedPage == 0 ? Colors.black : Colors.grey),
                  ),
                  child: Text(
                    'Upload Excel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedPage = 1;
                    });
                    _pageController.animateToPage(1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        _selectedPage == 1 ? Colors.black : Colors.grey),
                  ),
                  child: Text(
                    'Manual Entry',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedPage = index;
                });
              },
              children: [
                _buildUploadExcelSection(_collegeToken), // Pass collegeToken to the function
                _buildManualEntrySection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

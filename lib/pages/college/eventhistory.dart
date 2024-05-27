import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_constants.dart';
import 'package:intl/intl.dart';

class EventHistoryPage extends StatefulWidget {
  @override
  _EventHistoryPageState createState() => _EventHistoryPageState();
}

class _EventHistoryPageState extends State<EventHistoryPage> {
  List events = [];
  bool isLoading = true;
  late String studentCollegeId;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int studentCollegeIdInt = prefs.getInt('college_id') ?? 0; // Default value is 0
    studentCollegeId = studentCollegeIdInt.toString();
    final String collegeToken = prefs.getString('college_token') ?? '';
    final url = Uri.parse('${ApiConstants.baseUrl}/api/college/viewEvents');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'collegetoken': collegeToken,
      },
      body: json.encode({'college_id': studentCollegeId}),
    );

    if (response.statusCode == 200) {
      setState(() {
        events = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error
      print('Failed to load events');
    }
  }

  Future<void> fetchStudentDetails(String eventId, String collegeToken) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/college/viewStudents');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'collegetoken': collegeToken,
      },
      body: json.encode({'event_id': eventId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> studentDetails = json.decode(response.body);
      if (studentDetails.isNotEmpty) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: studentDetails.length,
                itemBuilder: (context, index) {
                  final student = studentDetails[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${student['student_name']}'),
                      Text('Roll No: ${student['student_rollno']}'),
                      Text('Admission No: ${student['student_admno']}'),
                      Text('Email: ${student['student_email']}'),
                      Text('Phone No: ${student['student_phone_no']}'),
                      Divider(),
                    ],
                  );
                },
              ),
            );
          },
        );
      } else {
        // Handle case when no student details are found
        print('No student details found');
      }
    } else {
      // Handle error
      print('Failed to load student details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final eventDate = DateTime.parse(event['event_private_date']);
          final formattedDate = DateFormat('yyyy-MM-dd').format(eventDate);

          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage('${ApiConstants.baseUrl}/${event['event_private_image']}'),
                backgroundColor: Colors.grey[200],
              ),
              title: Text(
                event['event_private_name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: $formattedDate'),
                    Text('Time: ${event['event_private_time']} AM'), // Assuming all times are AM
                    Text('Amount: ${event['event_private_amount']}'),
                    Text('Description: ${event['event_private_description']}'),
                  ],
                ),
              ),
              onTap: () async {
                // Handle event tap
                final String eventId = event['event_private_id'].toString(); // Convert to string
                print(eventId); // Print the event ID
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                final String collegeToken = prefs.getString('college_token') ?? '';
                await fetchStudentDetails(eventId, collegeToken); // Pass the event ID and token
              },
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EventHistoryPage(),
  ));
}

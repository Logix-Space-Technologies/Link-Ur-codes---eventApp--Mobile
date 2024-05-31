import 'package:event_app_mobile/pages/college/studentDetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> events = [];
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
    final url = Uri.parse('${ApiConstants.baseUrl}/api/college/getallevents');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'collegetoken': collegeToken,
      },
      body: json.encode({'college_id': studentCollegeId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> decodedResponse = json.decode(response.body);
      setState(() {
        events = decodedResponse.cast<Map<String, dynamic>>();
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

          bool isActive = event['status'] == 'Active';
          bool isExpired = event['status'] == 'Expired';

          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            color: isExpired ? Colors.grey[200] : Colors.white,
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        '${ApiConstants.baseUrl}/${event['event_private_image']}'),
                    backgroundColor: Colors.grey[200],
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? Colors.green
                            : (isExpired ? Colors.red : Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                event['event_private_name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isExpired ? Colors.grey : Colors.black,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: $formattedDate'),
                    Text('Time: ${event['event_private_time']}'), // Adjust as needed
                    Text('Amount: ${event['event_private_amount']}'),
                    Text('Description: ${event['event_private_description']}'),
                  ],
                ),
              ),
              onTap: isActive
                  ? () async {
                // Handle event tap
                final String eventId = event['event_private_id'].toString(); // Convert to string
                print(eventId); // Print the event ID
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('event_id', eventId);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentDetailsPage()));
              }
                  : null,
            ),
          );
        },
      ),
    );
  }
}

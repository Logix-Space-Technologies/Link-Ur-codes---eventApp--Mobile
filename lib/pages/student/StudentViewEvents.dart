import 'dart:convert';
import 'package:event_app_mobile/api_constants.dart';
import 'package:event_app_mobile/models/privateEventModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StudentEventView extends StatefulWidget {
  @override
  _StudentEventViewState createState() => _StudentEventViewState();
}

class _StudentEventViewState extends State<StudentEventView> {
  late Future<List<PrivateEvents>> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents();
  }

  Future<List<PrivateEvents>> fetchEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token') ?? '';

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/events/view-student-private-events'),
      headers: {
        'Content-Type': 'application/json',
        'token': token,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        List<PrivateEvents> events = (data['events'] as List).map((eventJson) {
          return PrivateEvents.fromJson(eventJson);
        }).toList();
        return events;
      } else {
        throw Exception('Failed to load events: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load events');
    }
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void handleFeedback(String eventId, String userId) async {
    // Retrieve user token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token') ?? '';

    try {
      // Send POST request to the backend API for feedback submission
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/feedback/addfeedbackstud'),
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
        body: jsonEncode({
          'eventId': eventId,
          'userId': userId,
        }),
      );

      // Handle response based on HTTP status code and data
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          // Show a success dialog if feedback submission is successful
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Feedback Submitted'),
              content: Text('Your feedback has been successfully submitted.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Throw an exception if feedback submission fails
          throw Exception('Failed to add feedback: ${data['message']}');
        }
      } else {
        // Throw an exception if HTTP request fails
        throw Exception('Failed to add feedback: ${response.statusCode}');
      }
    } catch (e) {
      // Catch and handle any exceptions that occur during feedback submission
      print('Error adding feedback: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to submit feedback. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void showFeedbackDialog(String eventId) {
    String feedbackText = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Submit Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter your feedback',
                hintText: 'Type here...',
              ),
              onChanged: (value) {
                feedbackText = value;
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Call handleFeedback with eventId and feedbackText
              handleFeedback(eventId, feedbackText);
              Navigator.of(context).pop();
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            Text(
              'Private Events',
              style: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Color(0xFFFFFFFF)),
        ),
      ),
      body: FutureBuilder<List<PrivateEvents>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events found'));
          } else {
            final events = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          '${ApiConstants.baseUrl}/${event.eventPrivateImage.replaceAll('\\', '/')}',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.eventPrivateName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(event.eventPrivateDescription, maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text('Date: ${formatDate(event.eventPrivateDate)}'),
                            Text('Time: ${event.eventPrivateTime}'),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => showFeedbackDialog(event.eventPrivateId.toString()),
                            child: Text('Give Feedback'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

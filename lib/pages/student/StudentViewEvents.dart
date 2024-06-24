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

  void handleFeedback(String eventId, String user_id) {
    Navigator.pushNamed(context, '/studentfeedback', arguments: {
      'eventId': eventId,
      'user_id': user_id,
    });
  }

  void handleSessions(String eventId, String user_id) {
    Navigator.pushNamed(context, '/sessions', arguments: {
      'eventId': eventId,
      'user_id': user_id,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 5,
            ),
            Text('Private Events',style: TextStyle(color:  Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
          ],
        ),
        leading: IconButton(onPressed: (){ Navigator.pop(context);}, icon:Icon(Icons.arrow_back_ios_new,color:  Color(
            0xFFFFFFFF),)),
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
                    children: [
                      Image.network(
                        '${ApiConstants.baseUrl}/${event.eventPrivateImage}',
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
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
                          IconButton(
                            icon: Icon(Icons.feedback),
                            onPressed: () => handleFeedback(event.eventPrivateId as String, ''),
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

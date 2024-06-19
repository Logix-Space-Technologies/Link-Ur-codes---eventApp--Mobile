import 'package:event_app_mobile/api_constants.dart';
import 'package:event_app_mobile/models/privateEventModel.dart';
import 'package:event_app_mobile/pages/admin/addPrivateEvent.dart';
import 'package:event_app_mobile/services/adminService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class PrivateEventPage extends StatefulWidget {
  const PrivateEventPage({Key? key}) : super(key: key);

  @override
  State<PrivateEventPage> createState() => _PrivateEventPageState();
}

class _PrivateEventPageState extends State<PrivateEventPage> {
  late Future<List<PrivateEvents>> privateEvents;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    privateEvents = loadPrivateEvents();
  }

  Future<List<PrivateEvents>> loadPrivateEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? adminToken = prefs.getString("admintoken");
    try {
      var response = await AdminService().getPrivateEvents(adminToken ?? "");
      return response.map<PrivateEvents>((item) => PrivateEvents.fromJson(item)).toList();
    } catch (e) {
      print("Error fetching private events: $e");
      throw e;
    }
  }

  Future<void> _searchEvents(String eventName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? admintoken = prefs.getString("admintoken");
    try {
      var searchResults = await AdminService.searchPrivateEvents(eventName, admintoken ?? "");
      if (searchResults != null && searchResults.isNotEmpty) {
        setState(() {
          privateEvents = Future.value(searchResults);
        });
      } else {
        // Display an error message indicating no data was found
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('No Data Found'),
            content: Text('No events matching the search criteria were found.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Reload the original events list
                  setState(() {
                    privateEvents = loadPrivateEvents();
                  });
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error searching events: $e");
      // Display an error message indicating search failed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while searching events.'),
          actions: [
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

  Future<void> _deleteEvent(int? eventPrivateId) async {
    if (eventPrivateId == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? adminToken = prefs.getString("admintoken");
    try {
      var response = await AdminService.deletePrivateEvent(eventPrivateId.toString(), adminToken ?? "");
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event deleted successfully')),
        );
        setState(() {
          privateEvents = loadPrivateEvents();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete event: ${response['error']}')),
        );
      }
    } catch (e) {
      print("Error deleting event: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _downloadSyllabus(String? syllabusPath) async {
    if (syllabusPath == null || syllabusPath.isEmpty) return;

    final Uri syllabusUrl = Uri.parse('${ApiConstants.baseUrl}/$syllabusPath');
    if (await canLaunch(syllabusUrl.toString())) {
      await launch(syllabusUrl.toString(), forceSafariVC: false);
    } else {
      throw 'Could not launch $syllabusUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Events',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 3),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    String eventName = _searchController.text.trim();
                    if (eventName.isNotEmpty) {
                      _searchEvents(eventName);
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PrivateEvents>>(
              future: privateEvents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Center(child: Text("No data available"));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      PrivateEvents event = snapshot.data![index];
                      String imageUrl = '${ApiConstants.baseUrl}/${event.eventPrivateImage}';
                      return Card(
                        color: Color(0xFF1D1E33),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image, color: Colors.white70);
                              },
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                            ),
                          ),
                          title: Text(event.eventPrivateName ?? "", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                                  SizedBox(width: 5),
                                  Text(
                                    event.eventPrivateDate != null ? DateFormat('MMM dd, yyyy').format(event.eventPrivateDate!) : "",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Amount: ${event.eventPrivateAmount ?? ""}",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Description: ${event.eventPrivateDescription ?? ""}",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Duration: ${event.eventPrivateDuration ?? 0} minutes",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Online: ${event.eventPrivateOnline ?? ""}",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Offline: ${event.eventPrivateOffline ?? ""}",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Recorded: ${event.eventPrivateRecorded ?? ""}",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 5),
                              if (event.eventPrivateSyllabus != null && event.eventPrivateSyllabus!.isNotEmpty)
                                Row(
                                  children: [
                                    Icon(Icons.picture_as_pdf, color: Colors.red),
                                    SizedBox(width: 5),
                                    InkWell(
                                      child: Text('Download Syllabus', style: TextStyle(color: Colors.blue)),
                                      onTap: () => _downloadSyllabus(event.eventPrivateSyllabus),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  // Add action here that should be performed when the edit button is pressed
                                  // For example: Navigate to a different screen to edit the event
                                  print('Edit button pressed');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_forever_sharp, color: Colors.red),
                                onPressed: () {
                                  _deleteEvent(event.eventPrivateId);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No data available"));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPrivateEvent()),
          );
        },
        backgroundColor: Colors.white, // Background color of the button
        foregroundColor: Color(0xFF1D1E33), // Color of the icon
        heroTag: "addPrivateEventFab", // Unique tag
        child: Icon(Icons.add), // Icon to display
      ),
    );
  }
}

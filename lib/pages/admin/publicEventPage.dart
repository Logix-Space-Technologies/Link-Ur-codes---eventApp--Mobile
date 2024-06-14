import 'package:event_app_mobile/api_constants.dart';
import 'package:event_app_mobile/models/publicEventModel.dart';
import 'package:event_app_mobile/pages/admin/addPublicEvent.dart';
import 'package:event_app_mobile/services/adminService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class PublicEventPage extends StatefulWidget {
  const PublicEventPage({super.key});

  @override
  State<PublicEventPage> createState() => _PublicEventPageState();
}

class _PublicEventPageState extends State<PublicEventPage> {
  late Future<List<PublicEvents>> publicEvents;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    publicEvents = loadPublicEvents();
  }

  Future<List<PublicEvents>> loadPublicEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String adminToken = prefs.getString("admintoken") ?? "";
    try {
      var response = await AdminService().getPublicEvents(adminToken);
      List<PublicEvents> events = response.map<PublicEvents>((item) => PublicEvents.fromJson(item)).toList();
      print("Fetched events: ${events.length}");
      return events;
    } catch (e) {
      print("Error fetching public events: $e");
      return [];
    }
  }

  Future<void> _searchEvents(String eventName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String admintoken = prefs.getString("admintoken") ?? "";
    try {
      var searchResults = await AdminService.searchPublicEvents(eventName, admintoken);
      if (searchResults != null && searchResults.isNotEmpty) {
        setState(() {
          publicEvents = Future.value(searchResults);
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('No Data Found'),
            content: Text('No events matching the search criteria were found.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    publicEvents = loadPublicEvents();
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

  Future<void> _deleteEvent(int? eventPublicId) async {
    if (eventPublicId == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String admintoken = prefs.getString("admintoken") ?? "";
    try {
      var response = await AdminService.deletePublicEvent(eventPublicId.toString(), admintoken);
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event deleted successfully')),
        );
        setState(() {
          publicEvents = loadPublicEvents();
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

  Future<void> _downloadSyllabus(String syllabusPath) async {
    final Uri syllabusUrl = Uri.parse('${ApiConstants.baseUrl}/$syllabusPath');
    if (await canLaunchUrl(syllabusUrl)) {
      await launchUrl(syllabusUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $syllabusUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Events',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 3),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    String eventName = _searchController.text.trim();
                    if (eventName.isNotEmpty) {
                      _searchEvents(eventName);
                    }
                  },
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PublicEvents>>(
              future: publicEvents,
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
                      PublicEvents event = snapshot.data![index];
                      String imageUrl = '${ApiConstants.baseUrl}/${event.eventPublicImage ?? ''}';
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
                          title: Text(event.eventPublicName ?? '', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                                  SizedBox(width: 5),
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(event.eventPublicDate),
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.white70, size: 16),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      event.eventVenue ?? '',
                                      style: TextStyle(color: Colors.white70),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Amount: ${event.eventPublicAmount}",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Description: ${event.eventPublicDescription}",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Duration: ${event.eventPublicDuration} minutes",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Online: ${event.eventPublicOnline ??  ''}",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Offline: ${event.eventPublicOffline ??  ''}",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Recorded: ${event.eventPublicRecorded??  ''}",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 5),
                              if (event.eventSyllabus != null && event.eventSyllabus.isNotEmpty)
                                Row(
                                  children: [
                                    Icon(Icons.picture_as_pdf, color: Colors.red),
                                    SizedBox(width: 5),
                                    InkWell(
                                      child: Text('Download Syllabus', style: TextStyle(color: Colors.blue)),
                                      onTap: () => _downloadSyllabus(event.eventSyllabus),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color:Colors.white),
                                onPressed: () {
                                  // Add action here that should be performed when the edit button is pressed
                                  // For example: Navigate to a different screen to edit the event
                                  print('Edit button pressed');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_forever_sharp, color: Colors.red),
                                onPressed: () {
                                  _deleteEvent(event.eventPublicId);
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
            MaterialPageRoute(builder: (context) => AddPublicEvent()),
          );
        },
        backgroundColor: Colors.white, // Background color of the button
        foregroundColor: Color(0xFF1D1E33), // Color of the icon
        heroTag: "addEventFab", // Unique tag
        child: Icon(Icons.add), // Icon to display
      ),
    );
  }
}

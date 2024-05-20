import 'package:event_app_mobile/api_constants.dart';
import 'package:event_app_mobile/models/publicEventModel.dart';
import 'package:event_app_mobile/pages/admin/addPublicEvent.dart';
import 'package:event_app_mobile/services/adminService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      return response.map<PublicEvents>((item) => PublicEvents.fromJson(item)).toList();
    } catch (e) {
      print("Error fetching public events: $e");
      throw e;
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
                      String imageUrl = '${ApiConstants.baseUrl}/${event.eventPublicImage}';
                      return Card(
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              imageUrl,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image);
                              },
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          title: Text(event.eventPublicName,style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(
                             "Venue: ${event.eventVenue}\nAmount: ${event.eventPublicAmount}\nDescription: ${event.eventPublicDescription}\nDate: ${event.eventPublicDate}"),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Add action here that should be performed when the edit button is pressed
                              // For example: Navigate to a different screen to edit the event
                              print('Edit button pressed');
                            },
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
        backgroundColor: Colors.black, // Background color of the button
        foregroundColor: Colors.white, // Color of the icon
        heroTag: "addEventFab", // Unique tag
        child: Icon(Icons.add), // Icon to display
      ),
    );
  }
}

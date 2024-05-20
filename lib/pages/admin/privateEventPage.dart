import 'package:event_app_mobile/api_constants.dart';
import 'package:event_app_mobile/models/privateEventModel.dart';
import 'package:event_app_mobile/pages/admin/addPrivateEvent.dart';
import 'package:event_app_mobile/services/adminService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivateEventPage extends StatefulWidget {
  const PrivateEventPage({super.key});

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
    String adminToken = prefs.getString("admintoken") ?? "";
    try {
      var response = await AdminService().getPrivateEvents(adminToken);
      return response.map<PrivateEvents>((item) => PrivateEvents.fromJson(item)).toList();
    } catch (e) {
      print("Error fetching private events: $e");
      throw e;
    }
  }

  Future<void> _searchEvents(String eventName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String admintoken = prefs.getString("admintoken") ?? "";
    try {
      var searchResults = await AdminService.searchPrivateEvents(eventName, admintoken);
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
                          title: Text(event.eventPrivateName,style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(
                                  "Amount: ${event.eventPrivateAmount}\n"
                                  "Description: ${event.eventPrivateDescription}\n"
                                  "Date: ${event.eventPrivateDate}"
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPrivateEvent()));
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        heroTag: "addPrivateEventFab",
        child: Icon(Icons.add),
      ),
    );
  }
}

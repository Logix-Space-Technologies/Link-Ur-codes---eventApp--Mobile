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
  String searchQuery = "";

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
      if (searchQuery.isNotEmpty) {
        return response.map<PrivateEvents>((item) => PrivateEvents.fromJson(item))
            .where((item) => item.eventPrivateName.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }
      return response.map<PrivateEvents>((item) => PrivateEvents.fromJson(item)).toList();
    } catch (e) {
      print("Error fetching private events: $e");
      throw e;
    }
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      privateEvents = loadPrivateEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Private Events...",
                  border: InputBorder.none,
                ),
                onChanged: updateSearchQuery,
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => updateSearchQuery(searchQuery),
            )
          ],
        ),
      ),
      body: FutureBuilder<List<PrivateEvents>>(
        future: privateEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                PrivateEvents event = snapshot.data![index];
                // Assume ApiConstants.baseUrl contains the base URL of your API
                String imageUrl = '${ApiConstants.baseUrl}/${event.eventPrivateImage}';
                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        imageUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image);
                          // String imageUrl = '${ApiConstants.baseUrl}/${event.eventPrivateImage}';
                        },
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    title: Text(event.eventPrivateName),
                    subtitle: Text(
                        "Name: ${event.eventPrivateName}\n"
                            "Amount: ${event.eventPrivateAmount}\n"
                            "Description: ${event.eventPrivateDescription}\n"
                            "Date: ${event.eventPrivateDate}"
                    ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPrivateEvent()));
        },
        label: Text("Add Event"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }
}

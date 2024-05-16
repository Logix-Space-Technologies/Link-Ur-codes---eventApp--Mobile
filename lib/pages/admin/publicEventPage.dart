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

  @override
  void initState() {
    super.initState();
    publicEvents = loadPublicEvents();
  }

  void handleSearch(){

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              child: TextField(  // Replacing SearchBar with TextField for demonstration
                decoration: InputDecoration(
                  hintText: "Search Public Events...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  // Implement search logic
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // You might want to trigger search based on the text field input
              },
            )
          ],
        ),
      ),
      body: FutureBuilder<List<PublicEvents>>(
        future: publicEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                PublicEvents event = snapshot.data![index];
                return Card(
                  child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        // child: Image.network(event.eventPublicImage),
                      ),
                    subtitle: Text("Name: ${event.eventPublicName}\nVenue: ${event.eventVenue}\nAmount: ${event.eventPublicAmount}\nDescription: ${event.eventPublicDescription}\nDate: ${event.eventPublicDate}"),
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
          Navigator.push(context,
              MaterialPageRoute(builder:
                  (context)=>AddPublicEvent()));
        },
        label: Text("Add Event"), // Text to display
        icon: Icon(Icons.add), // Icon to display
        backgroundColor: Colors.black, // Background color of the button
        foregroundColor: Colors.white, // Color of the icon and text
      ),
    );
  }
}

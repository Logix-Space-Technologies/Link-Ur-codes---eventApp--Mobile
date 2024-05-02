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

  @override
  void initState() {
    super.initState();
    privateEvents = loadPrivateEvents();
  }
  void handleSearch(){

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
                  hintText: "Search Private Events...",
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
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(event.eventPrivateImage),
                    ),
                    title: Text(event.eventPrivateName),
                    subtitle: Text("Name: ${event.eventPrivateName}\nAmount: ${event.eventPrivateAmount}\nDescription: ${event.eventPrivateDescription}\nDate: ${event.eventPrivateDate}"),
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
              (context)=>AddPrivateEvent()));
        },
        label: Text("Add Event"), // Text to display
        icon: Icon(Icons.add), // Icon to display
        backgroundColor: Colors.black, // Background color of the button
        foregroundColor: Colors.white, // Color of the icon and text
      ),
    );
  }
}

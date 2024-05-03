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
                return Card(
                  child: ListTile(
                    // leading: ClipRRect(
                    //   borderRadius: BorderRadius.circular(50),
                    //   child: Image.network("data:image/jpeg;base64,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"),
                    // ),
                    title: Text(event.eventPrivateName),
                    subtitle: Text("Name: ${event.eventPrivateName}\nAmount: ${event.eventPrivateAmount}\nDescription: ${event.eventPrivateDescription}\nDate: ${event.eventPrivateDate}"),
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

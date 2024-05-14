import 'package:event_app_mobile/models/publicEventModel.dart';
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
        title: Text("Public Events"),
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
                    leading: CircleAvatar(
                      child: Text(event.eventPublicName[0]),
                    ),
                    subtitle: Text("Name: ${event.eventPublicName}\nVenue: ${event.eventVenue}\nAmount: ${event.eventPublicAmount}\nDescription: ${event.eventPublicDescription}\nDate: ${event.eventPublicDate}"),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
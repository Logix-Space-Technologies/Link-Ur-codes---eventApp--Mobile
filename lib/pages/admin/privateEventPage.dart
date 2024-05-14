import 'package:event_app_mobile/models/privateEventModel.dart';
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
        title: Text("Private Events"),
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
    );
  }
}
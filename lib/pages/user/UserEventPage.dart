import 'package:event_app_mobile/models/publicEventModel.dart';
import 'package:event_app_mobile/pages/user/userHomePage.dart';
import 'package:event_app_mobile/services/adminService.dart';
import 'package:event_app_mobile/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserEventPage extends StatefulWidget {
  const UserEventPage({Key? key}) : super(key: key);

  @override
  State<UserEventPage> createState() => _UserEventPageState();
}

class _UserEventPageState extends State<UserEventPage> {
  late Future<List<PublicEvents>> publicEvents;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    publicEvents = loadPublicEvents();
  }

  Future<List<PublicEvents>> loadPublicEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = prefs.getString("user_token") ?? "";
    try {
      var response = await userApiService().getPublicEvents(user_token);
      if (response != null && response is List<dynamic>) {
        // Check if the response is not null and is of type List<dynamic>
        List<PublicEvents> events = response.map((item) => PublicEvents.fromJson(item)).toList();
        return events;
      } else {
        throw Exception('Failed to load public events');
      }
    } catch (e) {
      print("Error fetching public events: $e");
      throw e;
    }
  }

  Future<void> _searchEvents(String eventName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = prefs.getString("user_token") ?? "";
    try {
      var searchResults = await userApiService.searchPublicEvents(eventName, user_token);
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 5,
            ),
            Text('Public Events',style: TextStyle(color:  Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
          ],
        ),
        leading: IconButton(onPressed: (){ Navigator.pop(context);}, icon:Icon(Icons.arrow_back_ios_new,color:  Color(
            0xFFFFFFFF),)),
      ),
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
                    return Center(child: Text("No data found"));
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        PublicEvents event = snapshot.data![index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              event.eventPublicName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Venue: ${event.eventVenue}\nAmount: ${event
                                  .eventPublicAmount}\nDescription: ${event
                                  .eventPublicDescription}\nDate: ${event
                                  .eventPublicDate}",
                            ),
                          ),
                        );
                      },
                    );
                  }
                } else {
                  return Center(child: Text("No data available"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

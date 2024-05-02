import 'package:event_app_mobile/models/adminCollege.dart';
import 'package:event_app_mobile/pages/admin/addCollegePage.dart';
import 'package:event_app_mobile/services/adminService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminCollegePage extends StatefulWidget {
  const AdminCollegePage({super.key});

  @override
  State<AdminCollegePage> createState() => _AdminCollegePageState();
}

class _AdminCollegePageState extends State<AdminCollegePage> {
  late Future<List<Colleges>> colleges;

  @override
  void initState() {
    super.initState();
    colleges = loadColleges();
  }

  Future<List<Colleges>> loadColleges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String adminToken = prefs.getString("admintoken") ?? "";
    try {
      var response = await AdminService().getColleges(adminToken);
      return response.map<Colleges>((item) => Colleges.fromJson(item)).toList();
    } catch (e) {
      print("Error fetching colleges: $e");
      return [];  // Return an empty list in case of error
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
                  hintText: "Search colleges...",
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
      body: FutureBuilder<List<Colleges>>(
        future: colleges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error.toString()}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Colleges college = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(college.collegeName[0]), // Assuming collegeName is non-empty
                    ),
                    title: Text(college.collegeName),
                    subtitle: Text("Email: ${college.collegeEmail}\nPhone: ${college.collegePhone}"),
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
              MaterialPageRoute(builder: (context) => AddCollege()));
        },
        label: Text("Add College"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }
}

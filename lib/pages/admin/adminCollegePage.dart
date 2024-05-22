import 'package:event_app_mobile/api_constants.dart';
import 'package:event_app_mobile/models/adminCollege.dart';
import 'package:event_app_mobile/pages/admin/EditCollegeAdmin.dart';
import 'package:event_app_mobile/pages/admin/addCollegePage.dart';
import 'package:event_app_mobile/services/adminService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminCollegePage extends StatefulWidget {
  const AdminCollegePage({Key? key}) : super(key: key);

  @override
  State<AdminCollegePage> createState() => _AdminCollegePageState();
}

class _AdminCollegePageState extends State<AdminCollegePage> {
  TextEditingController _searchController = TextEditingController();
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

  Future<void> _saveToPreferences(String collegeIdAdmin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_clicked_college_id', collegeIdAdmin);
    print('Saved $collegeIdAdmin to SharedPreferences');
  }

  Future<void> _searchCollege(String collegeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String adminToken = prefs.getString("admintoken") ?? "";
    try {
      var searchResults = await AdminService.searchColleges(collegeName, adminToken);
      if (searchResults != null && searchResults.isNotEmpty) {
        setState(() {
          colleges = Future.value(searchResults);
        });
      } else {
        // Display an error message indicating no data was found
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('College Not Found'),
            content: Text('No colleges matching the search criteria were found.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Reload the original colleges list
                  setState(() {
                    colleges = loadColleges();
                  });
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error searching colleges: $e");
      // Display an error message indicating search failed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while searching colleges.'),
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
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search Colleges",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 3),
                    hintStyle: TextStyle(color: Colors.white),  // White hint text
                  ),
                  onSubmitted: (collegeName) {
                    collegeName = collegeName.trim();
                    if (collegeName.isNotEmpty) {
                      _searchCollege(collegeName);
                    }
                  },
                  style: TextStyle(color: Colors.black),  // White input text
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),  // Search icon color
              onPressed: () {
                String collegeName = _searchController.text.trim();
                if (collegeName.isNotEmpty) {
                  _searchCollege(collegeName);
                }
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
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Colleges college = snapshot.data![index];
                String imageUrl = '${ApiConstants.baseUrl}/${college.collegeImage}';
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
                    title: Text(college.collegeName),
                    subtitle: Text("Email: ${college.collegeEmail}\nPhone: ${college.collegePhone}"),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        print('Edit button pressed for: ${college.collegeId}');
                        await _saveToPreferences(college.collegeId.toString());
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context) => EditCollege()));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddCollege()));
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        heroTag: "addCollegeFab",
        child: Icon(Icons.add),
      ),
    );
  }
}

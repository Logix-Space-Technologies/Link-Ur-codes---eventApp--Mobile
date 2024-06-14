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
  late AdminService _adminService;
  @override
  void initState() {
    super.initState();
    _adminService = AdminService();
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


  Future<void> _deleteCollege(int? collegeId, int index) async {
    if (collegeId == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String adminToken = prefs.getString("admintoken") ?? "";

    try {
      var response = await _adminService.deleteCollege(collegeId.toString(), adminToken);
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('College deleted successfully')),
        );

        // Get current list of colleges from the future and update state
        List<Colleges> currentColleges = await colleges;
        setState(() {
          // Filter out the deleted college from the current list
          currentColleges.removeWhere((college) => college.collegeId == collegeId);
          colleges = Future.value(currentColleges);
        });

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error'] ?? 'Failed to delete college')),
        );
      }
    } catch (e) {
      print("Error deleting college: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while deleting college')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
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
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 3),
                  ),
                  onSubmitted: (collegeName) {
                    collegeName = collegeName.trim();
                    if (collegeName.isNotEmpty) {
                      _searchCollege(collegeName);
                    }
                  },
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
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
                String imageUrl = '${ApiConstants.baseUrl}/${college.collegeImage ?? ''}';
                return Card(
                  color: Color(0xFF1D1E33),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        imageUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, color: Colors.white70);
                        },
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    title: Text(college.collegeName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text("Email: ${college.collegeEmail}", style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 5),
                        Text("Phone: ${college.collegePhone}", style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 5),
                        Text("Website: ${college.collegeWebsite}", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () async {
                            print('Edit button pressed for: ${college.collegeId}');
                            await _saveToPreferences(college.collegeId.toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditCollege()),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_forever_sharp, color: Colors.red),
                          onPressed: () {
                            _deleteCollege(college.collegeId, index);
                          },
                        ),
                      ],
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCollege()),
          );
        },
        backgroundColor: Colors.white, // Background color of the button
        foregroundColor: Color(0xFF1D1E33), // Color of the icon
        heroTag: "addCollegeFab", // Unique tag
        child: Icon(Icons.add), // Icon to display
      ),
    );
  }
}

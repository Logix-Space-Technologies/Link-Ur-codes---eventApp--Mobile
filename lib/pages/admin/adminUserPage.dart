import 'package:event_app_mobile/api_constants.dart';
import 'package:event_app_mobile/models/userModel.dart';
import 'package:event_app_mobile/services/adminService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminUserPage extends StatefulWidget {
  const AdminUserPage({Key? key}) : super(key: key);

  @override
  State<AdminUserPage> createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  TextEditingController _searchController = TextEditingController();
  late Future<List<Users>> users;
  final AdminService _adminService = AdminService();

  @override
  void initState() {
    super.initState();
    users = loadUsers();
  }

  Future<List<Users>> loadUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String adminToken = prefs.getString("admintoken") ?? "";
    try {
      var response = await _adminService.getUsers(adminToken);
      return response.map<Users>((item) => Users.fromJson(item)).toList();
    } catch (e) {
      print("Error fetching users: $e");
      return []; // Return an empty list in case of error
    }
  }

  Future<void> _searchUser(String searchTerm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String adminToken = prefs.getString("admintoken") ?? "";
    try {
      var searchResults = await AdminService.searchUsers(searchTerm, adminToken);
      if (searchResults.isNotEmpty) {
        setState(() {
          users = Future.value(searchResults);
        });
      } else {
        _showDialog('Users Not Found', 'No users matching the search criteria were found.');
        setState(() {
          users = loadUsers();
        });
      }
    } catch (e) {
      print("Error searching users: $e");
      _showDialog('Error', 'An error occurred while searching users.');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                users = loadUsers();
              });
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
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
                    hintText: "Search Users",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 3),
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  onSubmitted: (searchTerm) {
                    searchTerm = searchTerm.trim();
                    if (searchTerm.isNotEmpty) {
                      _searchUser(searchTerm);
                    }
                  },
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                String searchTerm = _searchController.text.trim();
                if (searchTerm.isNotEmpty) {
                  _searchUser(searchTerm);
                }
              },
            )
          ],
        ),
      ),
      body: FutureBuilder<List<Users>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error.toString()}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Users user = snapshot.data![index];
                String imageUrl = user.userImage != null ? '${ApiConstants.baseUrl}/${user.userImage}' : 'default_image_url';
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
                    title: Text(user.userName),
                    subtitle: Text(
                        "Email: ${user.userEmail.isNotEmpty ? user.userEmail : 'N/A'}\n"
                            "Phone: ${user.userContactNo != null ? user.userContactNo.toString() : 'N/A'}\n"
                            "Qualification: ${user.userQualification != null ? user.userQualification : 'N/A'}\n"
                            "Skills: ${user.userSkills != null ? user.userSkills : 'N/A'}"
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
    );
  }
}

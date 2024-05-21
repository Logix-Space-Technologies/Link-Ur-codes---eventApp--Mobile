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
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Users>> users;
  String admintoken = '';

  @override
  void initState() {
    super.initState();
    _loadAdminToken();
    users = loadUsers();
  }

  Future<void> _loadAdminToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      admintoken = prefs.getString('admintoken') ?? '';
    });
  }

  Future<List<Users>> loadUsers() async {
    try {
      var response = await AdminService().getUsers(admintoken);
      if (response is List) {
        return response.map<Users>((item) => Users.fromJson(item as Map<String, dynamic>)).toList();
      } else if (response is Map) {
        return [Users.fromJson(response as Map<String, dynamic>)];
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      print("Error fetching users: $e");
      return []; // Return an empty list in case of error
    }
  }



  Future<void> searchUsers(String userName) async {
    try {
      var searchResults = await AdminService.searchUsers(userName, admintoken);
      if (searchResults != null && searchResults.isNotEmpty) {
        setState(() {
          users = Future.value(searchResults);
        });
      } else {
        // Display an error message indicating no data was found
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('No Data Found'),
            content: Text('No users matching the search criteria were found.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Reload the original users list
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
    } catch (e) {
      print("Error searching users: $e");
      // Display an error message indicating search failed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while searching users. Please try again later.'),
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
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Colleges',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 3),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      String userName = _searchController.text.trim();
                      if (userName.isNotEmpty) {
                        searchUsers(userName);
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Users>>(
                future: users,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error.toString()}"));
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Users user = snapshot.data![index];
                        String imageUrl = '${ApiConstants.baseUrl}/${user.userImage}';
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
                              "Email: ${user.userEmail}\nPhone: ${user.userContactNo}\nQualification: ${user.userQualification}\nSkills: ${user.userSkills}",
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
            ),
          ],
        ),
      ),
    );
  }
}

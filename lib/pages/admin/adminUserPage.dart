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
  late Future<List<Users>> users;

  @override
  void initState() {
    super.initState();
    users = loadUsers();
  }

  Future<List<Users>> loadUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String adminToken = prefs.getString("admintoken") ?? "";
    try {
      var response = await AdminService().getUsers(adminToken);
      return response.map<Users>((item) => Users.fromJson(item)).toList();
    } catch (e) {
      print("Error fetching users: $e");
      return []; // Return an empty list in case of error
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
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Users...",
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
      body: FutureBuilder<List<Users>>(
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
                return Card(
                  child: ListTile(
                    // leading: CircleAvatar(
                    //   backgroundImage: NetworkImage(user.userImage), // Use backgroundImage for loading network images
                    // ),
                    title: Text(user.userName),
                    subtitle: Text(
                        "Email: ${user.userEmail}\nPhone: ${user.userContactNo}\nQualification: ${user.userQualification}\nSkills: ${user.userSkills}"),

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

import 'package:event_app_mobile/services/userService.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<Map<String, dynamic>> userProfile;

  @override
  void initState() {
    super.initState();
    userProfile = userApiService().getUserProfile();
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
            Text(
              'Profile',
              style: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            var user = snapshot.data!;
            String imageUrl = 'http://localhost:8085/${user['image']}';
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user['image'] != null
                        ? NetworkImage(imageUrl)
                        : AssetImage('assets/default_avatar.png') as ImageProvider,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Name: ${user['name'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Email: ${user['email'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Contact: ${user['contact'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Qualification: ${user['qualification'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Skills: ${user['skills'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  // Add more fields as needed
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../services/collegeService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'collegelogin.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> _collegeDetails = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCollegeDetails();
  }

  Future<void> _loadCollegeDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final collegeToken = prefs.getString('college_token');
      final collegeService = CollegeLoginService(); // Create an instance of CollegeLoginService
      final collegeDetails = await collegeService.getCollegeDetails(
          collegeToken!);
      setState(() {
        _collegeDetails = collegeDetails;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading college details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60.0),
              // Display College Image
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                    _collegeDetails['college_image'] ?? ''),
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(height: 20.0),
              // Display College Name
              Text(
                _collegeDetails['college_name'] ?? 'College Name',
                style:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              // Display College Email
              Text(
                _collegeDetails['college_email'] ?? 'College Email',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10.0),
              // Display College Phone Number
              Text(
                _collegeDetails['college_phone'] ??
                    'College Phone Number',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20.0),
              // Button to update profile
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white
                ),
                onPressed: () {
                  // Add navigation logic for updating profile
                },
                child: Text('Update Profile'),
              ),
              SizedBox(height: 10.0),
              // Button to logout
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CollegeLogin()));
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

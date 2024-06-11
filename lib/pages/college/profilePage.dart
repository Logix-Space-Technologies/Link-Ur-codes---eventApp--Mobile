import 'package:event_app_mobile/pages/college/updatedetails.dart';
import 'package:flutter/material.dart';
import '../../api_constants.dart';
import '../../services/collegeService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'collegelogin.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> _facultyDetails = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFacultyDetails();
  }

  Future<void> _loadFacultyDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final collegeToken = prefs.getString('college_token');
      final facultyId = prefs.getInt('department_id');
      final collegeService = CollegeLoginService();
      final facultyDetails = await collegeService.getFacultyProfile(
          facultyId!, collegeToken!);
      setState(() {
        _facultyDetails = facultyDetails;
        print('_facultyDetails : $_facultyDetails');
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading faculty details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.logout),
          //   onPressed: () {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(builder: (context) => CollegeLogin()),
          //     );
          //   },
          // ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(
                '${ApiConstants.baseUrl}/${_facultyDetails['college_image']}',
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_facultyDetails['faculty_name'] ?? ''),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_facultyDetails['faculty_email'] ?? ''),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Phone',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_facultyDetails['faculty_phone'].toString() ?? ''),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Department',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_facultyDetails['department_name'] ?? ''),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'College',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_facultyDetails['college_name'] ?? ''),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('More Info'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => UpdateProfilePage(facultyDetails: _facultyDetails),
                ));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CollegeLogin()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

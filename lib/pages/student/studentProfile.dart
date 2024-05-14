// import 'package:flutter/material.dart';
// import 'package:event_app_mobile/models/studentModel.dart';
// import 'package:event_app_mobile/services/studentServices.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class studProfile extends StatefulWidget {
//   const studProfile({Key? key}) : super(key: key);
//
//   @override
//   State<studProfile> createState() => _studProfileState();
// }
//
// class _studProfileState extends State<studProfile> {
//   late Future<List<Student>> studdetails;
//   late int student_id;
//   late String token;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadStudentData();
//   }
//
//   Future<void> _loadStudentData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       student_id = prefs.getInt('student_id') ?? 0;
//       //token = prefs.getString('token') ?? '';
//       studdetails = StudentApiService().getstud(student_id.toString());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Student Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder<List<Student>>(
//           future: studdetails,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Student Details:',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   // Display student details in a box
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Student ID: ${snapshot.data![0].studentId}'),
//                         Text('Name: ${snapshot.data![0].studentName}'),
//                         Text('Roll No: ${snapshot.data![0].studentRollno}'),
//                         Text('Admission No: ${snapshot.data![0].studentAdmno}'),
//                         Text('Email: ${snapshot.data![0].studentEmail}'),
//                         Text('Phone No: ${snapshot.data![0].studentPhoneNo}'),
//                         Text('Event ID: ${snapshot.data![0].eventId}'),
//                         Text('College Name: ${snapshot.data![0].collegeName}'),
//                         Text('College Email: ${snapshot.data![0].collegeEmail}'),
//                         Text('College Phone: ${snapshot.data![0].collegePhone}'),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:event_app_mobile/models/studentModel.dart';
import 'package:event_app_mobile/services/studentServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class studProfile extends StatefulWidget {
  const studProfile({Key? key}) : super(key: key);

  @override
  State<studProfile> createState() => _studProfileState();
}

class _studProfileState extends State<studProfile> {
  late Future<List<Student>> studdetails;
  late int student_id;
  late String token;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      student_id = prefs.getInt('student_id') ?? 0;
      String token = prefs.getString('student_token') ?? '';
      studdetails = StudentApiService().getstud(student_id.toString(),token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Profile'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Student>>(
          future: studdetails,
          builder: (context, snapshot) {
            if (studdetails == null) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(child: CircularProgressIndicator());
            // } else if (snapshot.hasError) {
            //   return Center(child: Text('Error: ${snapshot.error}'));
            // } else {
            //   return Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('URL_TO_STUDENT_IMAGE'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    snapshot.data![0].studentName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Student Details:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // Display student details
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text('Student ID: ${snapshot.data![0].studentId}'),
                        ),
                        ListTile(
                          title: Text('Name: ${snapshot.data![0].studentName}'),
                        ),
                        ListTile(
                          title: Text('Roll No: ${snapshot.data![0].studentRollno}'),
                        ),
                        ListTile(
                          title: Text('Admission No: ${snapshot.data![0].studentAdmno}'),
                        ),
                        ListTile(
                          title: Text('Email: ${snapshot.data![0].studentEmail}'),
                        ),
                        ListTile(
                          title: Text('Phone No: ${snapshot.data![0].studentPhoneNo}'),
                        ),
                        // ListTile(
                        //   title: Text('Event ID: ${snapshot.data![0].eventId}'),
                        // ),
                        ListTile(
                          title: Text('College Name: ${snapshot.data![0].collegeName}'),
                        ),
                        ListTile(
                          title: Text('College Email: ${snapshot.data![0].collegeEmail}'),
                        ),
                        ListTile(
                          title: Text('College Phone: ${snapshot.data![0].collegePhone}'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

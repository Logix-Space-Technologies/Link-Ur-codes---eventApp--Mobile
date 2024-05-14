// // import 'package:flutter/material.dart';
// //
// // class StudMenu extends StatefulWidget {
// //   const StudMenu({Key? key}) : super(key: key);
// //
// //   @override
// //   State<StudMenu> createState() => _StudMenuState();
// // }
// //
// // class _StudMenuState extends State<StudMenu> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Student Menu'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             IconButton(
// //               icon: Icon(Icons.person),
// //               onPressed: () {
// //                 // Add functionality for profile
// //               },
// //             ),
// //             SizedBox(height: 20), // Adjust spacing as needed
// //             IconButton(
// //               icon: Icon(Icons.event),
// //               onPressed: () {
// //                 // Add functionality for events
// //               },
// //             ),
// //             SizedBox(height: 20), // Adjust spacing as needed
// //             IconButton(
// //               icon: Icon(Icons.event_available),
// //               onPressed: () {
// //                 // Add functionality for your events
// //               },
// //             ),
// //             SizedBox(height: 40), // Adjust spacing as needed
// //             ElevatedButton(
// //               onPressed: () {
// //                 // Add functionality for feedback
// //               },
// //               child: Text('Feedback'),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor:  Colors.black, // Background color
// //                 foregroundColor: Colors.white, // Text color
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // void main() {
// //   runApp(MaterialApp(
// //     home: StudMenu(),
// //   ));
// // }
// import 'package:event_app_mobile/pages/student/studentProfile.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class StudMenu extends StatefulWidget {
//   const StudMenu({Key? key}) : super(key: key);
//
//   @override
//   State<StudMenu> createState() => _StudMenuState();
// }
//
// class _StudMenuState extends State<StudMenu> {
//   late int _studentId;
//   late int _eventId;
//   late String _studentToken;
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
//       _studentId = prefs.getInt('student_id') ?? 0;
//       _eventId = prefs.getInt('event_id') ?? 0;
//       _studentToken = prefs.getString('student_token') ?? '';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Student Menu'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               icon: Icon(Icons.person,size: 80,),
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>studProfile()));
//                 // Add functionality for profile
//               },
//             ),
//             SizedBox(height: 20), // Adjust spacing as needed
//             IconButton(
//               icon: Icon(Icons.event,size: 80,),
//               onPressed: () {
//                 // Add functionality for events
//               },
//             ),
//             SizedBox(height: 20), // Adjust spacing as needed
//             IconButton(
//               icon: Icon(Icons.event_available,size: 80,),
//               onPressed: () {
//                 // Add functionality for your events
//               },
//             ),
//             SizedBox(height: 40), // Adjust spacing as needed
//             ElevatedButton(
//               onPressed: () {
//                 // Add functionality for feedback
//               },
//               child: Text('Feedback'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor:  Colors.black, // Background color
//                 foregroundColor: Colors.white, // Text color
//               ),
//             ),
//           ],
//         ),
//       ),
//
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: StudMenu(),
//   ));
// }
import 'package:event_app_mobile/pages/student/studentProfile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudMenu extends StatefulWidget {
  const StudMenu({Key? key}) : super(key: key);

  @override
  State<StudMenu> createState() => _StudMenuState();
}

class _StudMenuState extends State<StudMenu> {
  late int _studentId;
  late int _eventId;
  late String _studentToken;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _studentId = prefs.getInt('student_id') ?? 0;
      _eventId = prefs.getInt('event_id') ?? 0;
      _studentToken = prefs.getString('student_token') ?? '';
    });
  }

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    studProfile(),
    // Add your Events page here
    // Add your Feedback page here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Student Menu'),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StudMenu(),
  ));
}

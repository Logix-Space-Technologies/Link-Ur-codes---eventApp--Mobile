import 'package:event_app_mobile/pages/admin/adminCollegePage.dart';
import 'package:event_app_mobile/pages/admin/adminEventPage.dart';
import 'package:event_app_mobile/pages/admin/adminUserPage.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final List<Widget> pages = [
    AdminEventPage(),
    AdminCollegePage(),
    AdminUserPage()
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF1D1E33),
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: Text("Admin Page"),
          actions: [
            Tooltip(
              message: 'Payment History',  // Text that will be shown on hover/long press
              child: IconButton(
                icon: Icon(Icons.history, color: Colors.white),
                onPressed: () {
                  // Perform some action here when the history icon is pressed
                  print('History button pressed');
                },
              ),
            ),
          ],
        ),
        body: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFF1D1E33),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(color: Colors.white),
          unselectedLabelStyle: TextStyle(color: Colors.grey),
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
            BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: "Colleges"),
            BottomNavigationBarItem(icon: Icon(Icons.person_2_rounded), label: "Users")
          ],
        ),
      ),
    );
  }
}
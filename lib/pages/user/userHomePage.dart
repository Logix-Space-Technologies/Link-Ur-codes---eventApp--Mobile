import 'package:event_app_mobile/pages/student/StudentViewEvents.dart';
import 'package:event_app_mobile/pages/user/UserEventPage.dart';
import 'package:event_app_mobile/pages/user/UserFeedbackPage.dart';
import 'package:event_app_mobile/pages/user/UserProfilePage.dart';
import 'package:flutter/material.dart';

class UserMenu extends StatefulWidget {
  @override
  _UserMenuState createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    UserProfilePage(),
    UserEventPage(),
    StudentEventView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
            icon: Icon(Icons.event_repeat),
            label: 'Private Event ',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}






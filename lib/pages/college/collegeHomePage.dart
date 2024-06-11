import 'package:event_app_mobile/pages/college/profilePage.dart';
import 'package:event_app_mobile/pages/college/studentDetails.dart';
import 'package:flutter/material.dart';
import 'certificatePage.dart';
import 'eventPage.dart';
import 'eventhistory.dart';


class CollegeMenu extends StatefulWidget {
  @override
  _CollegeMenuState createState() => _CollegeMenuState();
}

class _CollegeMenuState extends State<CollegeMenu> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    ProfilePage(),
    CertificatePage(),
    EventPage(),
    EventHistoryPage()
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
            icon: Icon(Icons.history),
            label: 'Event History',
          ),
          BottomNavigationBarItem(
          icon: Icon(Icons.insert_page_break_outlined),
          label: 'Certificates',
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

import 'package:event_app_mobile/pages/user/UserEventPage.dart';
import 'package:event_app_mobile/pages/user/UserFeedbackPage.dart';
import 'package:flutter/material.dart';

class UserMenu extends StatefulWidget {
  @override
  _UserMenuState createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    ProfilePage(),
    UserEventPage(),
    EventHistoryPage(),
    UserFeedbackPage(),

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
            label: 'Event History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Feedback',
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



class ProfilePage extends StatelessWidget {
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
            Text('Profile',style: TextStyle(color:  Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
          ],
        ),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon:Icon(Icons.arrow_back_ios_new,color:  Color(
            0xFFFFFFFF),)),
      ),
    );
  }
}


class EventHistoryPage extends StatelessWidget {
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
            Text('Event History',style: TextStyle(color:  Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
          ],
        ),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon:Icon(Icons.arrow_back_ios_new,color:  Color(
            0xFFFFFFFF),)),
      ),
    );
  }
}
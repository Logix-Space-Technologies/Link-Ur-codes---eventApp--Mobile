import 'package:flutter/material.dart';
import 'package:event_app_mobile/pages/admin/adminlogin.dart';
import 'package:event_app_mobile/pages/college/collegelogin.dart';
import 'package:event_app_mobile/pages/student/studentLogin.dart';
import 'package:event_app_mobile/pages/user/userlogin.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/bglogo.png', // replace with your logo file name
                width: 250,
                height: 250,
              ),
            ),
            SizedBox(height: 20),
            LoginCard(
              title: 'Admin Login',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLogin()));
              },
              gradientColors: [Color(0xFF1D1E33), Color(0xff6aa4a1)],
            ),
            LoginCard(
              title: 'Faculty Login',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CollegeLogin()));
              },
              gradientColors: [Color(0xFF1D1E33), Color(0xff6aa4a1)],
            ),
            LoginCard(
              title: 'User Login',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserLogin()));
              },
              gradientColors: [Color(0xFF1D1E33), Color(0xff6aa4a1)],
            ),
          ],
        ),
      ),
    );
  }
}


class LoginCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final List<Color> gradientColors;

  LoginCard({required this.title, required this.onPressed, required this.gradientColors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 35, horizontal: 10),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

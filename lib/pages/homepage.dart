
import 'package:event_app_mobile/pages/admin/adminlogin.dart';
import 'package:event_app_mobile/pages/college/collegelogin.dart';
import 'package:event_app_mobile/pages/student/studentLogin.dart';
import 'package:event_app_mobile/pages/user/userlogin.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: const Text("ADMIN LOGIN"),
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminLogin()));
                },
              ),
              ListTile(
                title: const Text("USER LOGIN"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UserLogin()));
                },
              ),
              ListTile(
                title: const Text("COLLEGE LOGIN"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CollegeLogin()));
                },
              ),
              ListTile(
                title: const Text("STUDENT LOGIN"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentLogin()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:event_app_mobile/pages/admin/adminlogin.dart';
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
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Navigate to AdminLoginScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminLoginScreen()),
              );
            },
            child: Text('Go to Admin Login'),
          ),
        ),
      ),
    );
  }
}

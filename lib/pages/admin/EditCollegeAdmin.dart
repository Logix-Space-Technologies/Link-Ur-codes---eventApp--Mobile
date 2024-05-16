import 'package:flutter/material.dart';

class EditCollege extends StatefulWidget {
  const EditCollege({super.key});

  @override
  State<EditCollege> createState() => _EditCollegeState();
}

class _EditCollegeState extends State<EditCollege> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: Text("Admin Edit College Page"),
        ),
        body: Container(),
      ),
    );
  }
}

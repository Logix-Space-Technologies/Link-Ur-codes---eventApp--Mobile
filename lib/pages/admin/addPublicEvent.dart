import 'package:flutter/material.dart';

class AddPublicEvent extends StatefulWidget {
  const AddPublicEvent({super.key});

  @override
  State<AddPublicEvent> createState() => _AddPublicEventState();
}

class _AddPublicEventState extends State<AddPublicEvent> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text('Add Public Event'),
          leading: IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
        body: Container()
      ),
    );
  }
}

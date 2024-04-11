import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Success'),
      ),
      body: Center(
        child: Text(
          'Congratulations! You have successfully logged in.',
          style: TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:event_app_mobile/pages/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash_Screen extends StatefulWidget {
  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds:1), // Duration of the animation
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController); // Tween to control opacity from 0 to 1
    _animationController.forward(); // Start the animation

    Timer(Duration(seconds:2), () => Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF1D1E33),
                  Color(0xff6aa4a1)
                ]
            )
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation, // Apply fade-in animation to the child
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 100,
                  child: Image.asset('assets/logo.png'), // Your logo image
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
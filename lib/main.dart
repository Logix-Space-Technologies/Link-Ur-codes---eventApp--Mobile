import 'package:event_app_mobile/pages/SplashScreen.dart';
import 'package:flutter/material.dart';

void main()
{
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash_Screen(),
    );
  }
}

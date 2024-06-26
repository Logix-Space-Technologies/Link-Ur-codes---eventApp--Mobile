import 'package:event_app_mobile/pages/SplashScreen.dart';
import 'package:event_app_mobile/pages/student/studfeedbackpagePrivate.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash_Screen(),
      initialRoute: '/',
      routes: {
        // Define routes without passing eventId and userId directly
        '/studentfeedback': (context) => StudentFeedbackPage(
          eventId: ModalRoute.of(context)!.settings.arguments['eventId'],
          userId: ModalRoute.of(context)!.settings.arguments['userId'],
        ),
      },
    );
  }
}


import 'package:event_app_mobile/services/studentServices.dart';
import 'package:flutter/material.dart';

class StudForgotPassword extends StatefulWidget {
  const StudForgotPassword({Key? key}) : super(key: key);

  @override
  State<StudForgotPassword> createState() => _StudForgotPasswordState();
}

class _StudForgotPasswordState extends State<StudForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'To Create New Password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: forgotPassword,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
// void forgotpass()async
// {
//   final email=_emailController.text.trim();
//   final response=await StudentApiService().forgotpassword(email);
//
// }
  void forgotPassword() async {
    final email = _emailController.text.trim();
    final response = await StudentApiService().forgotpassword(email);
    if (response != null && response['success'] != null) {
      // Check if response is not null and 'success' property is not null
      if (response['success']) {
        // If success, show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // If failed, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Handle the case where response is null or 'success' property is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reset password. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
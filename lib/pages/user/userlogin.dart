import 'package:event_app_mobile/services/userService.dart';
import 'package:flutter/material.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false; // Add isLoading state

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    setState(() => isLoading = true); // Start loading
    final response = await userApiService().loginApi(
      emailController.text,
      passwordController.text,
    );

    if (response['status'] == 'Success') {
      print("success"); // Print success message
      // Navigate to next screen or perform successful login actions
    } else {
      // Handle different error scenarios
      setState(() {
        errorMessage = response['message'] ?? 'Unknown error occurred';
      });
    }
    setState(() => isLoading = false); // Stop loading
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: isLoading // Check if loading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "User Login",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            if (errorMessage.isNotEmpty) // Display error message if it exists
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(errorMessage, style: TextStyle(color: Colors.red)),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email ID",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                onPressed: login,
                child: Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

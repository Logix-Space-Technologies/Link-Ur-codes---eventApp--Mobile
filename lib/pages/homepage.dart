
import 'package:event_app_mobile/services/userService.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = ''; // Added to store error message

  // void login() async {
  //   try {
  //     final response = await userApiService().loginApi(
  //       emailController.text,
  //       passwordController.text,
  //     );
  //     // Handle response here
  //     if (response['status'] == 'Success') {
  //       print("success"); // Print success message
  //       // Successful login, navigate to next screen or perform appropriate actions
  //     } else {
  //       // Update errorMessage state to display error message
  //       setState(() {
  //         errorMessage = response['status'];
  //       });
  //     }
  //   } catch (e) {
  //     // Handle other errors, e.g., show a snackbar with an error message
  //     setState(() {
  //       errorMessage = 'An error occurred. Please try again later.';
  //     });
  //   }
  // }

  void login() async {
    try {
      final response = await userApiService().loginApi(
        emailController.text,
        passwordController.text,
      );

      if (response['status'] == 'Success') {
        print("success"); // Print success message
        Navigator.pop(context);
        // Successful login, navigate to next screen or perform appropriate actions
      } else {
        // Handle different error scenarios
        setState(() {
          if (response['status'] == 'Invalid Email ID') {
            errorMessage = 'Invalid Email ID';
          } else if (response['status'] == 'Invalid Password') {
            errorMessage = 'Invalid Password';
          }
        });
      }
    } catch (e) {
      // Handle network or server errors
      setState(() {
        errorMessage = 'An error occurred. Please check your internet connection and try again.';
      });
    }
  }



  // void login() async {
  //   try {
  //     final response = await userApiService().loginApi(
  //       emailController.text,
  //       passwordController.text,
  //     );
  //     // Handle response here
  //     if (response['status'] == 'Invalid Email ID' || response['status'] == 'Invalid Password') {
  //       // Update errorMessage state to display error message
  //       setState(() {
  //         errorMessage = response['status'];
  //       });
  //     } else {
  //       print("success");
  //       // Successful login, navigate to next screen or perform appropriate actions
  //     }
  //   } catch (e) {
  //     // Handle other errors, e.g., show a snackbar with an error message
  //     setState(() {
  //       errorMessage = 'An error occurred. Please try again later.';
  //     });
  //   }
  // }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "User Login",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            if (errorMessage.isNotEmpty) // Display error message if not empty
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: login,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // Set border radius to 0 for square shape
                    ),
                  ),
                ),
                child: Text("Login"),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Text(
                  "LIST  ",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              ListTile(
                title: const Text("ADMIN LOGIN"),
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                },
              ),
              ListTile(
                title: const Text("USER LOGIN"),
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                },
              ),
              ListTile(
                title: const Text("COLLEGE LOGIN"),
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                },
              ),
              ListTile(
                title: const Text("STUDENT LOGIN"),
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

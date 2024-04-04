import 'package:event_app_mobile/services/userService.dart';
import 'package:flutter/material.dart';

class userSignup extends StatefulWidget {
  const userSignup({super.key});

  @override
  State<userSignup> createState() => _userSignupState();
}

class _userSignupState extends State<userSignup> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  void regUser() async {
    final response = await UserApiService().sendData(
      name.text,
      email.text,
      pass.text,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your name",
                  labelText: "Name",
                  fillColor: Color(0xFF0dadae0).withOpacity(0.2),
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your email ID",
                  labelText: "Email ID",
                  fillColor: Color(0xFF0dadae0).withOpacity(0.2),
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: pass,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Password",
                  labelText: "Password",
                  fillColor: Color(0xFF0dadae0).withOpacity(0.2),
                  filled: true,
                  suffixIcon: Icon(Icons.key_outlined, color: Colors.deepOrange.withOpacity(0.3)),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.withOpacity(0.4),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: regUser,
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}

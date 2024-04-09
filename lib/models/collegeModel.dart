// To parse this JSON data, do
//
//     final collegelogin = collegeloginFromJson(jsonString);

import 'dart:convert';

List<Collegelogin> collegeloginFromJson(String str) => List<Collegelogin>.from(json.decode(str).map((x) => Collegelogin.fromJson(x)));

String collegeloginToJson(List<Collegelogin> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Collegelogin {
  String collegeEmail;
  String collegePassword;

  Collegelogin({
    required this.collegeEmail,
    required this.collegePassword,
  });

  factory Collegelogin.fromJson(Map<String, dynamic> json) => Collegelogin(
    collegeEmail: json["college_email"],
    collegePassword: json["college_password"],
  );

  Map<String, dynamic> toJson() => {
    "college_email": collegeEmail,
    "college_password": collegePassword,
  };
}
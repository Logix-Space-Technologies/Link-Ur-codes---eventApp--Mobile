// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

List<Users> usersFromJson(String str) => List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  int userId;
  String userName;
  String userEmail;
  String userPassword;
  int userContactNo;
  dynamic userImage;
  String userQualification;
  String userSkills;
  int userDeleteStatus;

  Users({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPassword,
    required this.userContactNo,
    required this.userImage,
    required this.userQualification,
    required this.userSkills,
    required this.userDeleteStatus,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    userId: json["user_id"],
    userName: json["user_name"],
    userEmail: json["user_email"],
    userPassword: json["user_password"],
    userContactNo: json["user_contact_no"],
    userImage: json["user_image"],
    userQualification: json["user_qualification"],
    userSkills: json["user_skills"],
    userDeleteStatus: json["user_delete_status"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "user_name": userName,
    "user_email": userEmail,
    "user_password": userPassword,
    "user_contact_no": userContactNo,
    "user_image": userImage,
    "user_qualification": userQualification,
    "user_skills": userSkills,
    "user_delete_status": userDeleteStatus,
  };
}
import 'dart:convert';

List<Users> usersFromJson(String str) => List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  int userId;
  String userName;
  String userEmail;
  String userPassword;
  int? userContactNo; // Changed to nullable int
  dynamic userImage;
  String? userQualification;
  String? userSkills;
  int userDeleteStatus;

  Users({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPassword,
    this.userContactNo, // Updated
    this.userImage,
    this.userQualification, // Updated
    this.userSkills, // Updated
    required this.userDeleteStatus,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    userId: json["user_id"],
    userName: json["user_name"],
    userEmail: json["user_email"],
    userPassword: json["user_password"],
    userContactNo: json["user_contact_no"], // Allow null
    userImage: json["user_image"],
    userQualification: json["user_qualification"], // Allow null
    userSkills: json["user_skills"], // Allow null
    userDeleteStatus: json["user_delete_status"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "user_name": userName,
    "user_email": userEmail,
    "user_password": userPassword,
    "user_contact_no": userContactNo, // Allow null
    "user_image": userImage,
    "user_qualification": userQualification, // Allow null
    "user_skills": userSkills, // Allow null
    "user_delete_status": userDeleteStatus,
  };
}

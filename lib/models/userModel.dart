import 'dart:convert';

List<Users> usersFromJson(String str) => List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  int? userId;
  String userName;
  String? userEmail;
  String? userPassword;
  int? userContactNo;
  String? userImage;
  String? userQualification;
  String? userSkills;
  int? userDeleteStatus;

  Users({
    this.userId,
    required this.userName,
    this.userEmail,
    this.userPassword,
    this.userContactNo,
    this.userImage,
    this.userQualification,
    this.userSkills,
    this.userDeleteStatus,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    userId: json["user_id"] != null ? json["user_id"] : null,
    userName: json["user_name"] != null ? json["user_name"] : null,
    userEmail: json["user_email"] != null ? json["user_email"] : null,
    userPassword: json["user_password"] != null ? json["user_password"] : null,
    userContactNo: json["user_contact_no"] != null ? json["user_contact_no"] : null,
    userImage: json["user_image"] != null ? json["user_image"] : null,
    userQualification: json["user_qualification"] != null ? json["user_qualification"] : null,
    userSkills: json["user_skills"] != null ? json["user_skills"] : null,
    userDeleteStatus: json["user_delete_status"] != null ? json["user_delete_status"] : null,
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

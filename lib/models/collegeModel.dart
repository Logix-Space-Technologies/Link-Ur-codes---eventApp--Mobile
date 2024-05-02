// To parse this JSON data, do
//
//     final collegelogin = collegeloginFromJson(jsonString);

import 'dart:convert';

List<Collegelogin> collegeloginFromJson(String str) => List<Collegelogin>.from(json.decode(str).map((x) => Collegelogin.fromJson(x)));

String collegeloginToJson(List<Collegelogin> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Collegelogin {
  int collegeId;
  String collegeName;
  String collegeEmail;
  String collegePhone;
  String collegePassword;
  String collegeImage;
  bool collegeCertificateRequest;
  bool deleteStatus;
  int collegeAddedBy;
  int collegeUpdatedBy;

  Collegelogin({
    required this.collegeId,
    required this.collegeName,
    required this.collegeEmail,
    required this.collegePhone,
    required this.collegePassword,
    required this.collegeImage,
    required this.collegeCertificateRequest,
    required this.deleteStatus,
    required this.collegeAddedBy,
    required this.collegeUpdatedBy,
  });

  factory Collegelogin.fromJson(Map<String, dynamic> json) => Collegelogin(
    collegeId: json["college_id"],
    collegeName: json["college_name"],
    collegeEmail: json["college_email"],
    collegePhone: json["college_phone"],
    collegePassword: json["college_password"],
    collegeImage: json["college_image"],
    collegeCertificateRequest: json["college_certificate_request"],
    deleteStatus: json["delete_status"],
    collegeAddedBy: json["college_addedby"],
    collegeUpdatedBy: json["college_updatedby"],
  );

  Map<String, dynamic> toJson() => {
    "college_id": collegeId,
    "college_name": collegeName,
    "college_email": collegeEmail,
    "college_phone": collegePhone,
    "college_password": collegePassword,
    "college_image": collegeImage,
    "college_certificate_request": collegeCertificateRequest,
    "delete_status": deleteStatus,
    "college_addedby": collegeAddedBy,
    "college_updatedby": collegeUpdatedBy,
  };
}
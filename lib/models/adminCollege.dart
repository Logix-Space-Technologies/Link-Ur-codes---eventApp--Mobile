// To parse this JSON data, do
//
//     final colleges = collegesFromJson(jsonString);

import 'dart:convert';

List<Colleges> collegesFromJson(String str) => List<Colleges>.from(json.decode(str).map((x) => Colleges.fromJson(x)));

String collegesToJson(List<Colleges> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Colleges {
  int collegeId;
  String collegeName;
  String collegeEmail;
  int collegePhone;
  String collegePassword;
  String? collegeImage;
  int collegeCertificateRequest;
  int deleteStatus;
  int collegeAddedby;
  int collegeUpdatedby;
  DateTime collegeAddedDate;
  DateTime collegeUpdatedDate;

  Colleges({
    required this.collegeId,
    required this.collegeName,
    required this.collegeEmail,
    required this.collegePhone,
    required this.collegePassword,
    required this.collegeImage,
    required this.collegeCertificateRequest,
    required this.deleteStatus,
    required this.collegeAddedby,
    required this.collegeUpdatedby,
    required this.collegeAddedDate,
    required this.collegeUpdatedDate,
  });

  factory Colleges.fromJson(Map<String, dynamic> json) => Colleges(
    collegeId: json["college_id"],
    collegeName: json["college_name"],
    collegeEmail: json["college_email"],
    collegePhone: json["college_phone"],
    collegePassword: json["college_password"],
    collegeImage: json["college_image"],
    collegeCertificateRequest: json["college_certificate_request"],
    deleteStatus: json["delete_status"],
    collegeAddedby: json["college_addedby"],
    collegeUpdatedby: json["college_updatedby"],
    collegeAddedDate: DateTime.parse(json["college_added_date"]),
    collegeUpdatedDate: DateTime.parse(json["college_updated_date"]),
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
    "college_addedby": collegeAddedby,
    "college_updatedby": collegeUpdatedby,
    "college_added_date": collegeAddedDate.toIso8601String(),
    "college_updated_date": collegeUpdatedDate.toIso8601String(),
  };
}

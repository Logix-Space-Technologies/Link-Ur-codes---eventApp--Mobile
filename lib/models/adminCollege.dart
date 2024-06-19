import 'dart:convert';

List<Colleges> collegesFromJson(String str) => List<Colleges>.from(json.decode(str).map((x) => Colleges.fromJson(x)));

String collegesToJson(List<Colleges> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Colleges {
  int? collegeId;
  String collegeName;
  String collegeEmail;
  int collegePhone;
  String collegeWebsite;
  String? collegePassword;
  String? collegeImage;
  int collegeCertificateRequest;
  int deleteStatus;
  int collegeAddedby;
  int collegeUpdatedby;
  DateTime collegeAddedDate;
  DateTime collegeUpdatedDate;

  Colleges({
    this.collegeId,
    required this.collegeName,
    required this.collegeEmail,
    required this.collegePhone,
    required this.collegeWebsite,
    this.collegePassword,
    this.collegeImage,
    required this.collegeCertificateRequest,
    required this.deleteStatus,
    required this.collegeAddedby,
    required this.collegeUpdatedby,
    required this.collegeAddedDate,
    required this.collegeUpdatedDate,
  });

  factory Colleges.fromJson(Map<String, dynamic> json) => Colleges(
    collegeId: json["college_id"] != null ? json["college_id"] : 0,
    collegeName: json["college_name"],
    collegeEmail: json["college_email"],
    collegePhone: json["college_phone"] != null ? json["college_phone"] : 0,
    collegeWebsite: json["college_website"],
    collegePassword: json["college_password"],
    collegeImage: json["college_image"],
    collegeCertificateRequest: json["college_certificate_request"] != null ? json["college_certificate_request"] : 0,
    deleteStatus: json["delete_status"] != null ? json["delete_status"] : 0,
    collegeAddedby: json["college_addedby"] != null ? json["college_addedby"] : 0,
    collegeUpdatedby: json["college_updatedby"] != null ? json["college_updatedby"] : 0,
    collegeAddedDate: json["college_added_date"] != null ? DateTime.parse(json["college_added_date"]) : DateTime.now(),
    collegeUpdatedDate: json["college_updated_date"] != null ? DateTime.parse(json["college_updated_date"]) : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "college_id": collegeId,
    "college_name": collegeName,
    "college_email": collegeEmail,
    "college_phone": collegePhone,
    "college_website": collegeWebsite,
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

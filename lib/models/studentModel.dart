// To parse this JSON data, do
//
//     final student = studentFromJson(jsonString);

import 'dart:convert';

List<Student> studentFromJson(String str) => List<Student>.from(json.decode(str).map((x) => Student.fromJson(x)));

String studentToJson(List<Student> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Student {
  int studentId;
  String studentName;
  int studentRollno;
  String studentAdmno;
  String studentEmail;
  int studentPhoneNo;
  int eventId;
  String collegeName;
  String collegeEmail;
  String collegePhone;

  Student({
    required this.studentId,
    required this.studentName,
    required this.studentRollno,
    required this.studentAdmno,
    required this.studentEmail,
    required this.studentPhoneNo,
    required this.eventId,
    required this.collegeName,
    required this.collegeEmail,
    required this.collegePhone,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    studentId: json["student_id"],
    studentName: json["student_name"],
    studentRollno: json["student_rollno"],
    studentAdmno: json["student_admno"],
    studentEmail: json["student_email"],
    studentPhoneNo: json["student_phone_no"],
    eventId: json["event_id"],
    collegeName: json["college_name"],
    collegeEmail: json["college_email"],
    collegePhone: json["college_phone"],
  );

  Map<String, dynamic> toJson() => {
    "student_id": studentId,
    "student_name": studentName,
    "student_rollno": studentRollno,
    "student_admno": studentAdmno,
    "student_email": studentEmail,
    "student_phone_no": studentPhoneNo,
    "event_id": eventId,
    "college_name": collegeName,
    "college_email": collegeEmail,
    "college_phone": collegePhone,
  };
}

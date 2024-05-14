// To parse this JSON data, do
//
//     final publicEvents = publicEventsFromJson(jsonString);

import 'dart:convert';

List<PublicEvents> publicEventsFromJson(String str) => List<PublicEvents>.from(json.decode(str).map((x) => PublicEvents.fromJson(x)));

String publicEventsToJson(List<PublicEvents> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PublicEvents {
  int eventPublicId;
  String eventPublicName;
  String eventPublicAmount;
  String eventPublicDescription;
  DateTime eventPublicDate;
  String eventPublicTime;
  dynamic eventPublicImage;
  String eventSyllabus;
  String eventVenue;
  int eventAddedby;
  int eventUpdatedby;
  int deleteStatus;
  int cancelStatus;

  PublicEvents({
    required this.eventPublicId,
    required this.eventPublicName,
    required this.eventPublicAmount,
    required this.eventPublicDescription,
    required this.eventPublicDate,
    required this.eventPublicTime,
    required this.eventPublicImage,
    required this.eventSyllabus,
    required this.eventVenue,
    required this.eventAddedby,
    required this.eventUpdatedby,
    required this.deleteStatus,
    required this.cancelStatus,
  });

  factory PublicEvents.fromJson(Map<String, dynamic> json) => PublicEvents(
    eventPublicId: json["event_public_id"],
    eventPublicName: json["event_public_name"],
    eventPublicAmount: json["event_public_amount"],
    eventPublicDescription: json["event_public_description"],
    eventPublicDate: DateTime.parse(json["event_public_date"]),
    eventPublicTime: json["event_public_time"],
    eventPublicImage: json["event_public_image"],
    eventSyllabus: json["event_syllabus"],
    eventVenue: json["event_venue"],
    eventAddedby: json["event_addedby"],
    eventUpdatedby: json["event_updatedby"],
    deleteStatus: json["delete_status"],
    cancelStatus: json["cancel_status"],
  );

  Map<String, dynamic> toJson() => {
    "event_public_id": eventPublicId,
    "event_public_name": eventPublicName,
    "event_public_amount": eventPublicAmount,
    "event_public_description": eventPublicDescription,
    "event_public_date": eventPublicDate.toIso8601String(),
    "event_public_time": eventPublicTime,
    "event_public_image": eventPublicImage,
    "event_syllabus": eventSyllabus,
    "event_venue": eventVenue,
    "event_addedby": eventAddedby,
    "event_updatedby": eventUpdatedby,
    "delete_status": deleteStatus,
    "cancel_status": cancelStatus,
  };
}
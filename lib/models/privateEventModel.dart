// To parse this JSON data, do
//
//     final privateEvents = privateEventsFromJson(jsonString);

import 'dart:convert';

List<PrivateEvents> privateEventsFromJson(String str) => List<PrivateEvents>.from(json.decode(str).map((x) => PrivateEvents.fromJson(x)));

String privateEventsToJson(List<PrivateEvents> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PrivateEvents {
  int eventPrivateId;
  String eventPrivateName;
  String eventPrivateAmount;
  String eventPrivateDescription;
  String eventPrivateDate;
  String eventPrivateTime;
  String eventPrivateImage;
  String collegeName;
  String eventAddedby;
  String eventUpdatedby;
  String deleteStatus;
  String cancelStatus;

  PrivateEvents({
    required this.eventPrivateId,
    required this.eventPrivateName,
    required this.eventPrivateAmount,
    required this.eventPrivateDescription,
    required this.eventPrivateDate,
    required this.eventPrivateTime,
    required this.eventPrivateImage,
    required this.collegeName,
    required this.eventAddedby,
    required this.eventUpdatedby,
    required this.deleteStatus,
    required this.cancelStatus,
  });

  factory PrivateEvents.fromJson(Map<String, dynamic> json) => PrivateEvents(
    eventPrivateId: json["event_private_id"],
    eventPrivateName: json["event_private_name"],
    eventPrivateAmount: json["event_private_amount"],
    eventPrivateDescription: json["event_private_description"],
    eventPrivateDate: json["event_private_date"],
    eventPrivateTime: json["event_private_time"],
    eventPrivateImage: json["event_private_image"],
    collegeName: json["college_name"],
    eventAddedby: json["event_addedby"],
    eventUpdatedby: json["event_updatedby"],
    deleteStatus: json["delete_status"],
    cancelStatus: json["cancel_status"],
  );

  Map<String, dynamic> toJson() => {
    "event_private_id": eventPrivateId,
    "event_private_name": eventPrivateName,
    "event_private_amount": eventPrivateAmount,
    "event_private_description": eventPrivateDescription,
    "event_private_date": eventPrivateDate,
    "event_private_time": eventPrivateTime,
    "event_private_image": eventPrivateImage,
    "college_name": collegeName,
    "event_addedby": eventAddedby,
    "event_updatedby": eventUpdatedby,
    "delete_status": deleteStatus,
    "cancel_status": cancelStatus,
  };
}
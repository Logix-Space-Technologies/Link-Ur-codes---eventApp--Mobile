// To parse this JSON data, do
//
//     final publicEvents = publicEventsFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

List<PublicEvents> publicEventsFromJson(String str) => List<PublicEvents>.from(json.decode(str).map((x) => PublicEvents.fromJson(x)));

String publicEventsToJson(List<PublicEvents> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PublicEvents {
  final int eventPublicId;
  final String eventPublicName;
  final String eventPublicAmount;
  final String eventPublicDescription;
  final DateTime eventPublicDate;
  final TimeOfDay eventPublicTime;
  final String? eventPublicImage;
  final String eventSyllabus;
  final String eventVenue;
  final int eventAddedBy;
  final int eventUpdatedBy;
  final DateTime eventAddedDate;
  final DateTime eventUpdatedDate;
  final bool deleteStatus;
  final bool cancelStatus;
  final int eventPublicDuration;
  final int eventPublicOnline;
  final int eventPublicOffline;
  final int eventPublicRecorded;

  PublicEvents({
    required this.eventPublicId,
    required this.eventPublicName,
    required this.eventPublicAmount,
    required this.eventPublicDescription,
    required this.eventPublicDate,
    required this.eventPublicTime,
    this.eventPublicImage,
    required this.eventSyllabus,
    required this.eventVenue,
    required this.eventAddedBy,
    required this.eventUpdatedBy,
    required this.eventAddedDate,
    required this.eventUpdatedDate,
    required this.deleteStatus,
    required this.cancelStatus,
    required this.eventPublicDuration,
    required this.eventPublicOnline,
    required this.eventPublicOffline,
    required this.eventPublicRecorded,
  });

  factory PublicEvents.fromJson(Map<String, dynamic> json) {
    return PublicEvents(
      eventPublicId: json['event_public_id'],
      eventPublicName: json['event_public_name'],
      eventPublicAmount: json['event_public_amount'],
      eventPublicDescription: json['event_public_description'],
      eventPublicDate: DateTime.parse(json['event_public_date']),
      eventPublicTime: TimeOfDay(
        hour: int.parse(json['event_public_time'].split(":")[0]),
        minute: int.parse(json['event_public_time'].split(":")[1]),
      ),
      eventPublicImage: json['event_public_image'],
      eventSyllabus: json['event_syllabus'],
      eventVenue: json['event_venue'],
      eventAddedBy: json['event_addedby'],
      eventUpdatedBy: json['event_updatedby'],
      eventAddedDate: DateTime.parse(json['event_added_date']),
      eventUpdatedDate: DateTime.parse(json['event_updated_date']),
      deleteStatus: json['delete_status'] == 1,
      cancelStatus: json['cancel_status'] == 1,
      eventPublicDuration: json['event_public_duration'],
      eventPublicOnline: json['event_public_online'],
      eventPublicOffline: json['event_public_offline'],
      eventPublicRecorded: json['event_public_recorded'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_public_id': eventPublicId,
      'event_public_name': eventPublicName,
      'event_public_amount': eventPublicAmount,
      'event_public_description': eventPublicDescription,
      'event_public_date': eventPublicDate.toIso8601String(),
      'event_public_time': '${eventPublicTime.hour}:${eventPublicTime.minute}',
      'event_public_image': eventPublicImage,
      'event_syllabus': eventSyllabus,
      'event_venue': eventVenue,
      'event_addedby': eventAddedBy,
      'event_updatedby': eventUpdatedBy,
      'event_added_date': eventAddedDate.toIso8601String(),
      'event_updated_date': eventUpdatedDate.toIso8601String(),
      'delete_status': deleteStatus ? 1 : 0,
      'cancel_status': cancelStatus ? 1 : 0,
      'event_public_duration': eventPublicDuration,
      'event_public_online': eventPublicOnline,
      'event_public_offline': eventPublicOffline,
      'event_public_recorded': eventPublicRecorded,
    };
  }
}

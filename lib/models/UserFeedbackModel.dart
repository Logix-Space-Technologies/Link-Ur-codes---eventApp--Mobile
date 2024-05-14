// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

List<UserFeedbackModel> userFeedbackModelFromJson(String str) => List<UserFeedbackModel>.from(json.decode(str).map((x) => UserFeedbackModel.fromJson(x)));
String userFeedbackModelToJson(List<UserFeedbackModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class UserFeedbackModel {
  final int feedbackId;
  final int feedbackUserId;
  final int feedbackEventId;
  final String feedbackContent;

  UserFeedbackModel({
    required this.feedbackId,
    required this.feedbackUserId,
    required this.feedbackEventId,
    required this.feedbackContent,
  });

  factory UserFeedbackModel.fromJson(Map<String, dynamic> json) {
    return UserFeedbackModel(
      feedbackId: json['feedback_id'],
      feedbackUserId: json['feedback_user_id'],
      feedbackEventId: json['feedback_event_id'],
      feedbackContent: json['feedback_content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedback_id': feedbackId,
      'feedback_user_id': feedbackUserId,
      'feedback_event_id': feedbackEventId,
      'feedback_content': feedbackContent,
    };
  }
}
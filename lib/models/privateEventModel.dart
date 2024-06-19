class PrivateEvents {
  int eventPrivateId;
  String eventPrivateName;
  String eventPrivateAmount;
  String eventPrivateDescription;
  DateTime eventPrivateDate;
  String eventPrivateTime;
  int? eventPrivateDuration;
  int? eventPrivateOnline;
  int? eventPrivateOffline;
  int? eventPrivateRecorded;
  String eventPrivateImage;
  int? eventPrivateClgid;
  String? eventPrivateSyllabus;// Make it nullable
  int? eventAddedby; // Make it nullable
  int? eventUpdatedby; // Make it nullable
  String? eventAddedDate; // Make it nullable
  String? eventUpdatedDate; // Make it nullable
  int? deleteStatus; // Make it nullable
  int? cancelStatus;
  int? isCompleted;// Make it nullable

  PrivateEvents({
    required this.eventPrivateId,
    required this.eventPrivateName,
    required this.eventPrivateAmount,
    required this.eventPrivateDescription,
    required this.eventPrivateDate,
    required this.eventPrivateTime,
    this.eventPrivateDuration,
    this.eventPrivateOnline,
    this.eventPrivateOffline,
    this.eventPrivateRecorded,
    required this.eventPrivateImage,
    this.eventPrivateSyllabus,
    this.eventPrivateClgid,
    this.eventAddedby,
    this.eventUpdatedby,
    this.eventAddedDate,
    this.eventUpdatedDate,
    this.deleteStatus,
    this.cancelStatus,
    this.isCompleted,
  });

  factory PrivateEvents.fromJson(Map<String, dynamic> json) {
    return PrivateEvents(
      eventPrivateId: json['event_private_id'],
      eventPrivateName: json['event_private_name'],
      eventPrivateAmount: json['event_private_amount'],
      eventPrivateDescription: json['event_private_description'],
      eventPrivateDate: DateTime.parse(json['event_private_date']),
      eventPrivateDuration: json['event_private_duration'],
      eventPrivateOnline: json['event_private_online'],
      eventPrivateOffline: json['event_private_offline'],
      eventPrivateRecorded: json['event_private_recorded'],
      eventPrivateTime: json['event_private_time'],
      eventPrivateImage: json['event_private_image'],
      eventPrivateSyllabus: json['event_private_syllabus'],
      eventPrivateClgid: json['event_private_clgid'] is String ? int.tryParse(json['event_private_clgid']) : json['event_private_clgid'],
      eventAddedby: json['event_addedby'] is String ? int.tryParse(json['event_addedby']) : json['event_addedby'],
      eventUpdatedby: json['event_updatedby'] is String ? int.tryParse(json['event_updatedby']) : json['event_updatedby'],
      eventAddedDate: json['event_added_date'],
      eventUpdatedDate: json['event_updated_date'],
      deleteStatus: json['delete_status'] is String ? int.tryParse(json['delete_status']) : json['delete_status'],
      cancelStatus: json['cancel_status'] is String ? int.tryParse(json['cancel_status']) : json['cancel_status'],
      isCompleted: json['is_completed'] is String ? int.tryParse(json['is_completed']) : json['is_completed'],

    );
  }
}

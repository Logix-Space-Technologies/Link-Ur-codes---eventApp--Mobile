class Admin {
  final int? adminId;  // Make adminId optional to handle cases where it may not be provided
  final String adminUsername;
  final String adminPassword;

  Admin({this.adminId, required this.adminUsername, required this.adminPassword});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      adminId: json['admin_id'],  // Extract admin_id from JSON
      adminUsername: json['admin_username'],
      adminPassword: json['admin_password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin_id': adminId,  // Include admin_id in JSON
      'admin_username': adminUsername,
      'admin_password': adminPassword,
    };
  }
}

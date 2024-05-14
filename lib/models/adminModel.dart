class Admin {
  final String adminUsername;
  final String adminPassword;

  Admin({required this.adminUsername, required this.adminPassword});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      adminUsername: json['admin_username'],
      adminPassword: json['admin_password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin_username': adminUsername,
      'admin_password': adminPassword,
    };
  }
}
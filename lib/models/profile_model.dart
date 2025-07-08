class ProfileModel {
  String id;
  String username;
  String email;
  DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    DateTime? createdAt,
  }) : createdAt =  DateTime.now().toUtc();

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json.containsKey('id') ? json['id'] ?? '' : '',
      username: json.containsKey('username') ? json['username'] ?? '' : '',
      email: json.containsKey('email') ? json['email'] ?? '' : '',
      createdAt: json.containsKey('created_at') && json['created_at'] != null
          ? DateTime.parse(json['created_at']).toUtc()
          : DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
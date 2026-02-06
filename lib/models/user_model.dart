enum UserRole { startup, official }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? profileImage;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] == 'official' ? UserRole.official : UserRole.startup,
      profileImage: json['profileImage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role == UserRole.official ? 'official' : 'startup',
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isOfficial => role == UserRole.official;
  bool get isStartup => role == UserRole.startup;
}
enum UserRole { startup, official }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? companyName;
  final String? profileImageUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.companyName,
    this.profileImageUrl,
    required this.createdAt,
  });

  bool get isStartup => role == UserRole.startup;
  bool get isOfficial => role == UserRole.official;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] == 'official' ? UserRole.official : UserRole.startup,
      companyName: json['companyName'],
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role == UserRole.official ? 'official' : 'startup',
      'companyName': companyName,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

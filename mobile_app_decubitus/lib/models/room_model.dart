import 'package:mobile_app_decubitus/models/user_model.dart';

class Room {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final User owner;

  const Room({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.owner,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      name: json['name'] as String,
      owner: _parseOwner(json['owner']),
    );
  }

  // Helper method to parse the owner field
  static User _parseOwner(Map<String, dynamic> ownerJson) {
    return User(
      id: ownerJson['id'] as int,
      ssid: ownerJson['ssid'] as String,
      firstName: ownerJson['first_name'] as String,
      lastName: ownerJson['last_name'] as String,
      profileImage: ownerJson['profile_image'] as String,
      roles: [], // Provide an empty list for roles
    );
  }
}

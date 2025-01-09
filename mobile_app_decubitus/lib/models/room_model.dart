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
      owner: User.fromJson(json['owner']),
    );
  }
}

class RoomResponse {
  final List<Room> rooms;

  const RoomResponse({
    required this.rooms,
  });

  factory RoomResponse.fromJson(List<dynamic> jsonList) {
    List<Room> roomList =
        jsonList.map((item) => Room.fromJson(item as Map<String, dynamic>)).toList();

    return RoomResponse(rooms: roomList);
  }
}

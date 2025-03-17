class FollowUp {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;
  final String imageUrl;
  final String area;
  final String status;
  final String type;
  final int? woundRef;
  final int count;
  final int perusalId;
  final WoundState woundState;

  FollowUp({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.imageUrl,
    required this.area,
    required this.status,
    required this.type,
    this.woundRef,
    required this.count,
    required this.perusalId,
    required this.woundState,
  });

  factory FollowUp.fromJson(Map<String, dynamic> json) {
    return FollowUp(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt']?.toString(),
      imageUrl: json['wound_image'],
      area: json['area'],
      status: json['status'],
      type: json['wound_type'],
      woundRef: json['wound_ref'],
      count: json['count'],
      perusalId: json['perusal_id'],
      woundState: WoundState.fromJson(json['wound_state']),
    );
  }
}

class WoundState {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;
  final int state;
  final String description;

  WoundState({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.state,
    required this.description,
  });

  factory WoundState.fromJson(Map<String, dynamic> json) {
    return WoundState(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt']?.toString(),
      state: json['state'],
      description: json['description'],
    );
  }
}

class WoundState {
  final int id;
  final String createdAt;
  final String updatedAt;
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
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      state: json['state'],
      description: json['description'],
    );
  }
}

class Wound {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String woundImage;
  final String area;
  final String status;
  final String woundType;
  final int? woundRef;
  final int count;
  final WoundState woundState;

  Wound({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.woundImage,
    required this.area,
    required this.status,
    required this.woundType,
    this.woundRef,
    required this.count,
    required this.woundState,
  });

  factory Wound.fromJson(Map<String, dynamic> json) {
    return Wound(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      woundImage: json['wound_image'],
      area: json['area'],
      status: json['status'],
      woundType: json['wound_type'],
      woundRef: json['wound_ref'],
      count: json['count'],
      woundState: WoundState.fromJson(json['wound_state']),
    );
  }
}

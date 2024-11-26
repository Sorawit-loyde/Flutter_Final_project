// wound_model.dart

class Wound {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt; // Nullable field
  final String woundImage;
  final String area;
  final String status;

  Wound({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.woundImage,
    required this.area,
    required this.status,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'wound_image': woundImage,
      'area': area,
      'status': status,
    };
  }
}

class WoundGroup {
  final String area;
  final List<Wound> wounds;
  final int count;
  final Map<String, int> statusBreakdown;

  WoundGroup({
    required this.area,
    required this.wounds,
    required this.count,
    required this.statusBreakdown,
  });

  factory WoundGroup.fromJson(Map<String, dynamic> json) {
    var woundsJson = json['wounds'] as List;
    List<Wound> woundsList = woundsJson.map((w) => Wound.fromJson(w)).toList();

    return WoundGroup(
      area: json['area'],
      wounds: woundsList,
      count: json['count'],
      statusBreakdown: Map<String, int>.from(json['statusBreakdown']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'wounds': wounds.map((w) => w.toJson()).toList(),
      'count': count,
      'statusBreakdown': statusBreakdown,
    };
  }
}

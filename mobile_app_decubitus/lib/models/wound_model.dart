// wound_model.dart

class Wound {
  final int id; // Wound ID
  final int perusalId; // Foreign key from Perusal
  final String woundImage; // Image path or URL
  final String area; // Area of the wound
  final String status; // Status of the wound
  final String woundType; // Type of wound (new or old)
  final int? woundRef; // Reference ID for old wounds (nullable)

  Wound({
    required this.id,
    required this.perusalId,
    required this.woundImage,
    required this.area,
    required this.status,
    required this.woundType,
    this.woundRef, // Allow null for reference ID
  });

  Map<String, dynamic> toJson() {
    return {
      'perusal_id': perusalId,
      'wound_image': woundImage,
      'area': area,
      'status': status,
      'wound_type': woundType,
      'wound_ref': woundRef,
    };
  }

  factory Wound.fromJson(Map<String, dynamic> json) {
    return Wound(
      id: json['id'], // Capture the wound ID from the response
      perusalId: json['perusal_id'] ?? 0, // Default to 0 if null
      woundImage: json['wound_image'] ?? '', // Default to empty string if null
      area: json['area'] ?? '', // Default to empty string if null
      status: json['status'] ?? '', // Default to empty string if null
      woundType: json['wound_type'] ?? '', // Default to empty string if null
      woundRef: json['wound_ref'], // Allow null for reference ID
    );
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

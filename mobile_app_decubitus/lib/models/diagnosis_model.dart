class Diagnosis {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final int state;
  final String description;
  final List<Treatment> treat;
  final String woundImage;
  final int perusalId; // Add perusalId

  Diagnosis({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.state,
    required this.description,
    required this.treat,
    required this.woundImage,
    required this.perusalId, // Initialize perusalId
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    var treatList = json['treat'] as List;
    List<Treatment> treat =
        treatList.map((i) => Treatment.fromJson(i)).toList();

    return Diagnosis(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      state: json['state'],
      description: json['description'],
      treat: treat,
      woundImage: json['wound_image'],
      perusalId: json['persual_id'], // Map perusalId from JSON
    );
  }
}

class Treatment {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String description;

  Treatment({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.description,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      description: json['description'],
    );
  }
}

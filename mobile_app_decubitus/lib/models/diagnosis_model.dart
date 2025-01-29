class Diagnosis {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final int state;
  final String description;
  final List<Treatment> treat;
  final String woundImage;
  final int perusalId;
  final String woundStatus;
  final int count;
  final String? remark;
  final int patientId; // Add patientId field

  Diagnosis({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.state,
    required this.description,
    required this.treat,
    required this.woundImage,
    required this.perusalId,
    required this.woundStatus,
    required this.count,
    this.remark,
    required this.patientId, // Initialize patientId
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    try {
      var treatList = json['treat'] as List;
      List<Treatment> treat =
          treatList.map((i) => Treatment.fromJson(i)).toList();

      return Diagnosis(
        id: json['id'] as int,
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
        deletedAt: json['deletedAt'] as String?,
        state: json['state'] as int,
        description: json['description'] as String,
        treat: treat,
        woundImage: json['wound_image'] as String,
        perusalId: json['persual_id'] as int,
        woundStatus: json['wound_status'] as String,
        count: json['count'] as int,
        remark: json['remark'] as String?,
        patientId: json['patient_id'] as int, // Parse patientId
      );
    } catch (e) {
      throw Exception('Failed to parse Diagnosis JSON: $e');
    }
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

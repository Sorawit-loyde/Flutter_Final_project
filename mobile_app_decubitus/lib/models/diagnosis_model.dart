class DiagnosisModel {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final int state;
  final String description;
  final List<Treatment> treat;
  final String woundImage;

  DiagnosisModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.state,
    required this.description,
    required this.treat,
    required this.woundImage,
  });

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) {
    var treatList = json['treat'] as List;
    List<Treatment> treat =
        treatList.map((i) => Treatment.fromJson(i)).toList();

    return DiagnosisModel(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      state: json['state'],
      description: json['description'],
      treat: treat,
      woundImage: json['wound_image'],
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

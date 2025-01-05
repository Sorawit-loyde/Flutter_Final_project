class FollowUp {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;
  final String imageUrl;
  final String area;
  final String status;
  final String type;
  final String? reference;
  final int count;
  final int perusalId;

  FollowUp({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.imageUrl,
    required this.area,
    required this.status,
    required this.type,
    this.reference,
    required this.count,
    required this.perusalId,
  });

  factory FollowUp.fromJson(Map<String, dynamic> json) {
    return FollowUp(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt'],
      imageUrl: json['wound_image'],
      area: json['area'],
      status: json['status'],
      type: json['wound_type'],
      reference: json['wound_ref'],
      count: json['count'],
      perusalId: json['perusal_id'],
    );
  }
}

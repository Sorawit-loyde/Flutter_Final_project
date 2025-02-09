class Perusal {
  final int id;
  final DateTime createdAt;
  final DateTime perusalDate;
  int originalIndex; // Add this property

  Perusal({
    required this.id,
    required this.createdAt,
    required this.perusalDate,
    this.originalIndex = 0, // Initialize with a default value
  });

  // Add a method to copy the Perusal with an updated originalIndex
  Perusal copyWith({int? originalIndex}) {
    return Perusal(
      id: id,
      createdAt: createdAt,
      perusalDate: perusalDate,
      originalIndex: originalIndex ?? this.originalIndex,
    );
  }

  factory Perusal.fromJson(Map<String, dynamic> json) {
    return Perusal(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      perusalDate: DateTime.parse(json['perusal_date'] as String),
    );
  }
}

class PerusalResponse {
  final List<Perusal> data;

  const PerusalResponse({
    required this.data,
  });

  factory PerusalResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List<dynamic>;
    List<Perusal> perusals =
        dataList.map((item) => Perusal.fromJson(item)).toList();

    return PerusalResponse(data: perusals);
  }
}

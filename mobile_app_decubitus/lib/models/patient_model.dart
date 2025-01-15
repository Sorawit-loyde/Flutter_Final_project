class Patient {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String ssid;
  final String sex;
  final String firstName;
  final String lastName;
  final String profileImage;

  Patient({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.ssid,
    required this.sex,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      ssid: json['ssid'],
      sex: json['sex'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profileImage: json['profile_image'],
    );
  }
}

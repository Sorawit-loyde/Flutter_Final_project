class userpf {
  final int id;
  final String? ssid;
  final String? firstName;
  final String? lastName;
  final String? profileImage;
  final String? gender;
  final String? birthDate;
  final String? phone;
  final List<Role> roles;

  const userpf({
    required this.id,
    required this.ssid,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.gender,
    required this.birthDate,
    required this.phone,
    required this.roles,
  });

  factory userpf.fromJson(Map<String, dynamic> json) {
    return userpf(
      id: json['id'] as int,
      ssid: json['ssid'] ?? 'N/A',
      firstName: json['first_name'] ?? 'N/A',
      lastName: json['last_name'] ?? 'N/A',
      profileImage: json['profile_image'] ?? 'N/A',
      gender: json['sex'] ?? 'N/A',
      birthDate: json['birthdate'] ?? 'N/A',
      phone: json['phone'] ?? 'N/A',
      roles: (json['role'] as List<dynamic>)
          .map((roleJson) => Role.fromJson(roleJson))
          .toList(),
    );
  }
}

class Role {
  final int id;
  final String name;
  final String description;

  const Role({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }
}

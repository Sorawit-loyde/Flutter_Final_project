class userpf {
  final int id;
  final String? ssid;
  final String? first_name;
  final String? last_name;
  final String? profile_image;
  final String? sex;
  final String? birthdate;
  final String? phone;
  final String? password; // Add password field
  final List<Role> roles;

  const userpf({
    required this.id,
    required this.ssid,
    required this.first_name,
    required this.last_name,
    required this.profile_image,
    required this.sex,
    required this.birthdate,
    required this.phone,
    required this.password, // Add password field
    required this.roles,
  });

  factory userpf.fromJson(Map<String, dynamic> json) {
    return userpf(
      id: json['id'] as int,
      ssid: json['ssid'] ?? 'N/A',
      first_name: json['first_name'] ?? 'N/A',
      last_name: json['last_name'] ?? 'N/A',
      profile_image: json['profile_image'] ?? 'N/A',
      sex: json['sex'] ?? 'N/A',
      birthdate: json['birthdate'] ?? 'N/A',
      phone: json['phone'] ?? 'N/A',
      password: json['password'] ?? 'N/A', // Add password field
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

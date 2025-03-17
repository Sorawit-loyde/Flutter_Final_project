class User {
  final int id;
  final String ssid;
  final String firstName;
  final String lastName;
  final String profileImage;
  final List<Role> roles;

  const User({
    required this.id,
    required this.ssid,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      ssid: json['ssid'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      profileImage: json['profile_image'] as String,
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

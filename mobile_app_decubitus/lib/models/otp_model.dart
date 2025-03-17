class OtpResponse {
  final String code;
  final String detail;
  final OtpResult result;
  final int uid; // New attribute

  OtpResponse({
    required this.code,
    required this.detail,
    required this.result,
    required this.uid, // New attribute
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      code: json['code'],
      detail: json['detail'],
      result: OtpResult.fromJson(json['result']),
      uid: json['uid'], // New attribute
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'detail': detail,
      'result': result.toJson(),
      'uid': uid, // New attribute
    };
  }
}

class OtpResult {
  final String token;
  final String refCode;

  OtpResult({required this.token, required this.refCode});

  factory OtpResult.fromJson(Map<String, dynamic> json) {
    return OtpResult(
      token: json['token'],
      refCode: json['ref_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'ref_code': refCode,
    };
  }
}

class User {
  final int id;
  final String ssid;
  final String sex;
  final String phone;
  final String firstName;
  final String lastName;
  final String birthdate;
  final String profileImage;
  final int roleId;

  User({
    required this.id,
    required this.ssid,
    required this.sex,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.profileImage,
    required this.roleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      ssid: json['ssid'],
      sex: json['sex'],
      phone: json['phone'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthdate: json['birthdate'],
      profileImage: json['profile_image'],
      roleId: json['role'][0]['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ssid': ssid,
      'sex': sex,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'birthdate': birthdate,
      'profile_image': profileImage,
      'roleId': roleId,
    };
  }
}

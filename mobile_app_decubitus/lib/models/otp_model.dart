class OtpResponse {
  final String code;
  final String detail;
  final OtpResult result;

  OtpResponse({required this.code, required this.detail, required this.result});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      code: json['code'],
      detail: json['detail'],
      result: OtpResult.fromJson(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'detail': detail,
      'result': result.toJson(),
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

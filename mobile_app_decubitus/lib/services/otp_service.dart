import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/otp_model.dart';
import '../config/config.dart';

class OtpService {
  static const String baseUrl = '${Custom_Config.BASE_URL}/auth';

  Future<OtpResponse> sendOtp(String phoneNumber) async {
    final response =
        await http.get(Uri.parse('$baseUrl/send-otp/$phoneNumber'));

    print(
        'sendOtp response: ${response.statusCode} - ${response.body}'); // Log the response

    if (response.statusCode == 200) {
      return OtpResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to send OTP');
    }
  }

  Future<bool> verifyOtp(String token, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
        'otp': otp,
      }),
    );

    print(
        'verifyOtp response: ${response.statusCode} - ${response.body}'); // Log the response

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

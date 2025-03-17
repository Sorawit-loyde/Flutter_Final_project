import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/otp_model.dart';
import '../config/config.dart';
import 'key_service.dart';

class OtpService {
  static const String baseUrl = '${Custom_Config.BASE_URL}/auth';

  Future<OtpResponse> sendOtp(String phoneNumber) async {
    final response =
        await http.get(Uri.parse('$baseUrl/send-otp/$phoneNumber'));

    print(
        'sendOtp response: ${response.statusCode} - ${response.body}'); // Log the response

    if (response.statusCode == 200) {
      final otpResponse = OtpResponse.fromJson(json.decode(response.body));
      print('UID: ${otpResponse.uid}'); // Log the UID
      return otpResponse;
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      return responseBody['result']['status'] == true;
    } else {
      return false;
    }
  }
}

class UserService {
  final String publicKey = Custom_Config.PUBLIC_KEY;
  static const String baseUrl = '${Custom_Config.BASE_URL}/users';
  final RSAService rsaService = RSAService(Custom_Config.PUBLIC_KEY);

  Future<void> updateUserDetails(int id, String password) async {
    print('Updating user details for user ID: $id');

    // Encrypt the password before sending it
    final encryptedPassword = await rsaService.encryptPassword(password);
    final requestBody = jsonEncode({'password': encryptedPassword});
    print('Final request body: $requestBody');

    final response = await http.patch(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody,
    );

    print(
        'updateUserDetails response: ${response.statusCode} - ${response.body}'); // Log the response

    if (response.statusCode != 200) {
      throw Exception('Failed to update user details');
    }
  }
}

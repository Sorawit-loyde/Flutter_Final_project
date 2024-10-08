import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:logger/logger.dart';

import '../config/config.dart';

class AuthService {
  var logger = Logger();
  Future<void> signIn(String ssid, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.BASE_URL}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'ssid': ssid, 'password': password}), // Adjusted key
      );
      logger.i('Response status: ${response.statusCode}');
      logger.i('Response body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        await _saveTokens(data['accessToken'], data['refreshToken']);
      } else {
        throw Exception('Failed to sign in');
      }
    } catch (e) {
      logger.e(e);
      throw Exception('Failed to sign in');
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String password,
    required int ssnId,
    required String sex,
    required int phone,
    required String dateOfBirth,
    required String profileImage,
    required int roleId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.BASE_URL}/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'first_name': firstName,
          'last_name': lastName,
          'password': password,
          'ssid': ssnId,
          'sex': sex,
          'phone': phone,
          'birthdate': dateOfBirth,
          'profile_image': profileImage,
          'roleId': roleId,
        }),
      );

      logger.i('Response status: ${response.statusCode}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create account');
      }
    } catch (e) {
      logger.e(e);
      throw Exception('Failed to create account');
    }
  }

  Future<String?> getAccessToken() async {
    const storage = FlutterSecureStorage();
    return storage.read(key:'accessToken');
  }

  Future<String?> getRefreshToken() async {
    const storage = FlutterSecureStorage();
    return storage.read(key:'refreshToken');
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    const storage = FlutterSecureStorage();
    final jwt = JWT.decode(accessToken);
    final payload = jwt.payload;
    final String? userId = payload['Uid']?.toString();
    final prefs = await SharedPreferences.getInstance();

    if (userId != null) {
      await prefs.setString('Uid', userId);
    }

    await storage.write(key: 'accessToken',value: accessToken);
    await storage.write(key: 'refreshToken',value: refreshToken);
  }
}

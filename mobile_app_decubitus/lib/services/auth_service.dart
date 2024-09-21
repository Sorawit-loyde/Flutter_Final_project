import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/config.dart';

class AuthService {
  Future<void> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.BASE_URL}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_name': email, 'password': password}),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        await _saveTokens(data['accessToken'], data['refreshToken']);
      } else {
        throw Exception('Failed to sign in');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to sign in');
    }
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }
}

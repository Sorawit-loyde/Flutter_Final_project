import 'package:shared_preferences/shared_preferences.dart';

import '../config/config.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Config.TOKEN_KEY, token);
  }

  Future<User> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Config.BASE_URL}/signin'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _saveToken(data['token']);
      return User.fromJson(data['user']);
    } else {
      throw Exception('Failed to sign in');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';

class AuthService {
  Future<void> signIn(String ssid, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.BASE_URL}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'ssid': ssid, 'password': password}), // Adjusted key
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

  Future<void> register({
    required String firstName,
    required String lastName,
    required String password,
    required int ssnId, // Assuming this is still needed for registration
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
          'ssid': ssnId, // Ensure this matches your API requirements
          'sex': sex,
          'date_of_birth': dateOfBirth,
          'profile_image': profileImage,
          'roleId': roleId,
        }),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode != 201) {
        throw Exception('Failed to create account');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to create account');
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

import 'package:mobile_app_decubitus/models/user_profile_model.dart'; // Import new model
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/config.dart';
import 'auth_service.dart';
class UserProfileService {
  var logger = Logger();

  Future<userpf> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('Uid'); // Retrieve user ID
      final response = await http.get(
        Uri.parse('${Config.BASE_URL}/users/$id'),
        headers: {'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}"},
      );
      logger.t(response.body);
      logger.t(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return userpf.fromJson(data); // Parse the response into userpf
      } else {
        logger.e('Status code error: ${response.statusCode}');
        throw Exception('Failed to fetch user profile: ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e.toString());
      throw Exception('Error fetching user profile: $e');
    }
  }
}

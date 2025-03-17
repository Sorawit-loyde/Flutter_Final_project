import 'package:mobile_app_decubitus/models/user_model.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/config.dart';
import 'auth_service.dart';

class UserService {
  var logger = Logger();

  Future<User> getprofile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('Uid');
      final response = await http.get(
        Uri.parse('${Custom_Config.BASE_URL}/users/profile/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}"
        },
      );
      logger.t(response.body);
      logger.t(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        logger.e('status code error');
        throw Exception('status code error');
      }
    } catch (e) {
      logger.e(e);
      throw Exception('Failed to getProfile');
    }
  }

  Future<int> getRoleId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('Uid');
      final response = await http.get(
        Uri.parse('${Custom_Config.BASE_URL}/users/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}",
        },
      );

      logger.t(response.body);
      logger.t(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['role'] != null && (data['role'] as List).isNotEmpty) {
          return data['role'][0]['id'] as int;
        } else {
          logger.w('No roles found for user');
          return 0; // Default or error role_id
        }
      } else {
        logger.e('status code error');
        throw Exception('Status code error');
      }
    } catch (e) {
      logger.e(e);
      throw Exception('Failed to fetch roleId');
    }
  }
}

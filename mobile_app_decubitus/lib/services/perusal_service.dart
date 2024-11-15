import 'package:mobile_app_decubitus/models/perusal_model.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/config.dart';
import 'auth_service.dart';

class PerusalService {
  var logger = Logger();

  Future<List<Perusal>> getPerusals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('Uid');

      logger.i('Fetching perusals for user ID: $id');

      final response = await http.get(
        Uri.parse('${Config.BASE_URL}/perusal/Pages/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}"
        },
      );

      logger.t('Response status: ${response.statusCode}');
      logger.t('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final perusalResponse = PerusalResponse.fromJson(jsonData);
        return perusalResponse.data;
      } else {
        logger.e('Status code error: ${response.statusCode}');
        throw Exception('Status code error');
      }
    } catch (e) {
      logger.e(e);
      throw Exception('Failed to getPerusals');
    }
  }
}

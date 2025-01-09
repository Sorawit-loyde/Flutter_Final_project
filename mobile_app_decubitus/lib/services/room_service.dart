import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/models/room_model.dart';
import 'package:mobile_app_decubitus/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class RoomService {
    var logger = Logger();

  Future<List<Room>> getRooms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('Uid');

      final response = await http.get(
        Uri.parse('${Custom_Config.BASE_URL}/rooms/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}"
        },
      );

      logger.t('Response status: ${response.statusCode}');
      logger.t('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonData = json.decode(response.body);
        final roomResponse = RoomResponse.fromJson(jsonData);
        return roomResponse.rooms;
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
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/models/room_model.dart';
import 'package:mobile_app_decubitus/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          'Authorization': "Bearer ${await AuthService().getAccessToken()}",
        },
      );

      logger.d('Response status: ${response.statusCode}');
      logger.d('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if the body is empty or null
        if (response.body.isEmpty) {
          throw Exception('Empty response body from server');
        }

        // Decode the response body
        final List<dynamic> jsonData = json.decode(response.body);

        // Map the JSON data to a list of Room objects
        return jsonData.map((item) => Room.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to fetch rooms. Status code: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching rooms: $e');
      throw Exception('Error fetching rooms: $e');
    }
  }
}

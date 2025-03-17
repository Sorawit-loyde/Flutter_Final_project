import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app_decubitus/models/wound_list_model.dart';
import 'package:mobile_app_decubitus/config/config.dart';

class WoundService {
  final String baseUrl = Custom_Config.BASE_URL;

  Future<List<Wound>> fetchWounds(int woundId) async {
    final url = Uri.parse('$baseUrl/wound/followup/$woundId');
    print('Sending request to: $url'); // Log the URL being sent

    final response = await http.get(url);

    print(
        'Received response: ${response.statusCode}'); // Log the response status code
    print('Response body: ${response.body}'); // Log the response body

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Wound.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load wounds');
    }
  }
}

// wound_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app_decubitus/models/wound_model.dart';

class WoundService {
  final String baseUrl;

  WoundService(this.baseUrl);

  Future<List<WoundGroup>> fetchGroupedWounds(int perusalId) async {
    final url = '$baseUrl/wound/wounds/grouped/$perusalId';
    print('Fetching wounds from: $url'); // Log the URL being fetched

    final response = await http.get(Uri.parse(url));

    print('Response status: ${response.statusCode}'); // Log the response status
    print('Response body: ${response.body}'); // Log the response body

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => WoundGroup.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load grouped wounds');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app_decubitus/models/diagnosis_model.dart';
import 'package:mobile_app_decubitus/config/config.dart';

class DiagnosisService {
  final String baseUrl = '${Custom_Config.BASE_URL}/diagnosis/wound/';

  Future<DiagnosisModel> fetchDiagnosis(int woundId) async {
    final url = Uri.parse('$baseUrl$woundId');
    print('Fetching diagnosis data from: $url');

    try {
      final response = await http.get(url);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return DiagnosisModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load diagnosis data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load diagnosis data');
    }
  }
}

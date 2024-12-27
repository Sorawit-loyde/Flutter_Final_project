import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app_decubitus/models/diagnosis_model.dart';
import 'package:mobile_app_decubitus/config/config.dart';

class DiagnosisService {
  final String baseUrl = '${Custom_Config.BASE_URL}/diagnosis/wound/';

  Future<DiagnosisModel> fetchDiagnosis(int woundId) async {
    final response = await http.get(Uri.parse('$baseUrl$woundId'));

    if (response.statusCode == 200) {
      return DiagnosisModel.fromJson(json.decode(response.body)[0]);
    } else {
      throw Exception('Failed to load diagnosis data');
    }
  }
}

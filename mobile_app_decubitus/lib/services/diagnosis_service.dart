import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:mobile_app_decubitus/models/diagnosis_model.dart';
import 'package:mobile_app_decubitus/config/config.dart';

class DiagnosisService {
  // Fetch a diagnosis by wound ID
  Future<Diagnosis> fetchDiagnosis(int woundId) async {
    final url = Uri.parse('${Custom_Config.BASE_URL}/diagnosis/wound/$woundId');
    print('Fetching diagnosis data from: $url');

    try {
      final response = await http.get(url);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Diagnosis.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load diagnosis data. Status code: ${response.statusCode} Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load diagnosis data');
    }
  }

  // Update diagnosis with PATCH and retrieve nurse ID from SharedPreferences
  Future<void> updateDiagnosis({
    required int woundId,
    required int woundState,
    String? remark,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final nurseId =
        prefs.getString('Uid'); // Retrieve nurseId from SharedPreferences

    if (nurseId == null) {
      throw Exception('Nurse ID not found in SharedPreferences');
    }

    final url = Uri.parse('${Custom_Config.BASE_URL}/diagnosis/$woundId');
    print('Updating diagnosis data to: $url');

    try {
      final body = json.encode({
        'wound_id': woundId,
        'nurse_id': int.parse(nurseId), // Parse nurseId to integer
        'wound_state': woundState,
        'remark': remark ?? '', // Send empty string if remark is null
      });

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update diagnosis data. Status code: ${response.statusCode} Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update diagnosis data');
    }
  }
}

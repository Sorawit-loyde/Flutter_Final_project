import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mobile_app_decubitus/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app_decubitus/models/diagnosis_model.dart';
import 'package:mobile_app_decubitus/config/config.dart';

class DiagnosisService {
  var logger = Logger();

  // Fetch a diagnosis by wound ID
  Future<Diagnosis> fetchDiagnosis(int woundId) async {
    final url = Uri.parse('${Custom_Config.BASE_URL}/diagnosis/wound/$woundId');
    logger.i('Fetching diagnosis data from: $url');

    try {
      final response = await http.get(url);

      logger.i('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Diagnosis.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load diagnosis data. Status code: ${response.statusCode} Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      logger.e('Error: $e');
      throw Exception('Failed to load diagnosis data');
    }
  }

  // Update diagnosis with PATCH and retrieve nurse ID from SharedPreferences
  Future<void> updateDiagnosis({
    required int woundId,
    required int diagnosisId,
    required int woundState,
    String? remark,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final nurseId =
        prefs.getString('Uid'); // Retrieve nurseId from SharedPreferences
    print(woundId);
    print(diagnosisId);
    print(woundState);
    if (nurseId == null) {
      throw Exception('Nurse ID not found in SharedPreferences');
    }

    final url = Uri.parse('${Custom_Config.BASE_URL}/diagnosis/$diagnosisId');
    logger.i('Updating diagnosis data to: $url');

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

      logger.i('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update diagnosis data. Status code: ${response.statusCode} Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      logger.e('Error: $e');
      throw Exception('Failed to update diagnosis data');
    }
  }

  Future<void> joinRoomwithPerusal(int perusalId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final nurseId =
          prefs.getString('Uid'); // Retrieve nurseId from SharedPreferences
      final url = Uri.parse(
          '${Custom_Config.BASE_URL}/rooms/perusal/$perusalId/$nurseId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}"
        },
      );

      logger.i('Response body: ${response.body}');
    } catch (e) {
      logger.e('Error create room: $e');
      throw Exception('Error at create room');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app_decubitus/models/patient_model.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class ApiService {
  var logger = Logger();
  // Fetch all patients for the dialog
  Future<List<Patient>> fetchAllPatients() async {
    final response =
        await http.get(Uri.parse('${Custom_Config.BASE_URL}/users/role/2'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> patientList = data['data'];
      return patientList.map((json) => Patient.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }

  // Fetch patients assigned to a specific nurse (dynamic nurse_id)
  Future<List<Patient>> fetchNursePatients() async {
    final prefs = await SharedPreferences.getInstance();
    final nurseId = prefs.getString('Uid');
    final response = await http.get(
      Uri.parse('${Custom_Config.BASE_URL}/users/patient/$nurseId'),
    );
    logger.t(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((json) {
        final patientJson = json['patient'];
        return Patient.fromJson({
          'id': json['patient_id'],
          'createdAt': patientJson['createdAt'],
          'updatedAt': patientJson['updatedAt'],
          'ssid': patientJson['ssid'],
          'sex': patientJson['sex'],
          'first_name': patientJson['first_name'],
          'last_name': patientJson['last_name'],
          'profile_image': patientJson['profile_image'],
          'patient_status': json['patient_status'],
        });
      }).toList();
    } else {
      throw Exception('Failed to load nurse patients');
    }
  }
}

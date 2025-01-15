import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app_decubitus/models/patient_model.dart';
import 'package:mobile_app_decubitus/config/config.dart';

class ApiService {
  final String baseUrl = '${Custom_Config.BASE_URL}/users/role/2';

  Future<List<Patient>> fetchPatients() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> patientList = data['data'];
      return patientList.map((json) => Patient.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }
}

import 'package:mobile_app_decubitus/models/perusal_model.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/config.dart';
import 'auth_service.dart';

class PerusalService {
  var logger = Logger();
  Future<List<Perusal>> getPerusalsNurse(id) async {
    try {
      final response = await http.get(
        Uri.parse('${Custom_Config.BASE_URL}/perusal/Pages/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}"
        },
      );

      logger.t('Response status: ${response.statusCode}');
      logger.t('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final perusalResponse = PerusalResponse.fromJson(jsonData);
        return perusalResponse.data;
      } else {
        logger.e('Status code error: ${response.statusCode}');
        throw Exception('Status code error');
      }
    } catch (e) {
      logger.e(e);
      throw Exception('Failed to getPerusals');
    }
  }

  Future<List<Perusal>> getPerusals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('Uid');

      logger.i('Fetching perusals for user ID: $id');

      final response = await http.get(
        Uri.parse('${Custom_Config.BASE_URL}/perusal/Pages/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}"
        },
      );

      logger.t('Response status: ${response.statusCode}');
      logger.t('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final perusalResponse = PerusalResponse.fromJson(jsonData);
        return perusalResponse.data;
      } else {
        logger.e('Status code error: ${response.statusCode}');
        throw Exception('Status code error');
      }
    } catch (e) {
      logger.e(e);
      throw Exception('Failed to getPerusals');
    }
  }

  Future<void> addPerusal(DateTime perusalDate) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final patientId = prefs.getString('Uid');
      final url = Uri.parse('${Custom_Config.BASE_URL}/perusal');

      final payload = jsonEncode({
        'perusal_date': perusalDate.toIso8601String(),
        'patient_id': patientId,
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}"
        },
        body: payload,
      );

      logger.t('Response status: ${response.statusCode}');
      logger.t('Response body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        logger.e('Failed to save perusal: ${response.body}');
        throw Exception('Failed to save perusal: ${response.body}');
      }

      final responseData = jsonDecode(response.body);

      final int perusalId = responseData['id'];
      final int ownerId = int.parse(responseData['user']['id']);
      final String perusaldate = responseData['perusal_date'];

      await createRoom(perusalId, ownerId, perusaldate);
    } catch (e) {
      logger.e('Error occurred while saving perusal: $e');
      throw Exception('Error occurred while saving perusal');
    }
  }

  Future<void> NurseaddPerusal(DateTime perusalDate, id) async {
    try {
      final url = Uri.parse('${Custom_Config.BASE_URL}/perusal');

      final payload = jsonEncode({
        'perusal_date': perusalDate.toIso8601String(),
        'patient_id': id.toString(),
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}"
        },
        body: payload,
      );

      logger.t('Response status: ${response.statusCode}');
      logger.t('Response body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        logger.e('Failed to save perusal: ${response.body}');
        throw Exception('Failed to save perusal: ${response.body}');
      }

      final responseData = jsonDecode(response.body);

      final int perusalId = responseData['id'];
      final int ownerId = int.parse(responseData['user']['id']);
      final String perusaldate = responseData['perusal_date'];

      await createRoom(perusalId, ownerId, perusaldate);
    } catch (e) {
      logger.e('Error occurred while saving perusal: $e');
      throw Exception('Error occurred while saving perusal');
    }
  }

  Future<void> createRoom(int perusalId, int ownerId, String roomName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final patientId = prefs.getString('Uid');
      final url = Uri.parse('${Custom_Config.BASE_URL}/rooms');
      final payload = jsonEncode(
          {'name': roomName, 'perusalId': patientId, 'ownerId': ownerId});
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}"
        },
        body: payload,
      );

      logger.t('Response status: ${response.statusCode}');
      logger.t('Response body: ${response.body}');
    } catch (e) {
      logger.e('Error create room: $e');
      throw Exception('Error at create room');
    }
  }

  Future<void> deletePerusal(int id) async {
    try {
      final url = Uri.parse(
          '${Custom_Config.BASE_URL}/perusal/$id'); // Use the appropriate endpoint

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}"
        },
      );

      logger.t('Response status: ${response.statusCode}');
      logger.t('Response body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        // Check for success status codes
        logger.e('Failed to delete perusal: ${response.body}');
        throw Exception('Failed to delete perusal: ${response.body}');
      }
    } catch (e) {
      logger.e('Error occurred while deleting perusal: $e');
      throw Exception('Error occurred while deleting perusal');
    }
  }

  Future<String> getPatientName(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${Custom_Config.BASE_URL}/users/profile/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final firstName = jsonData['first_name'] as String;
        final lastName = jsonData['last_name'] as String;
        return '$firstName $lastName';
      } else {
        throw Exception('Failed to fetch patient name');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching patient name: $e');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app_decubitus/models/wound_follow_up_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app_decubitus/config/config.dart';

class FollowUpService {
  // Method to fetch follow-ups based on the patient ID
  Future<List<FollowUp>> fetchFollowUps(String patientId) async {
    try {
      // Retrieve the user ID from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('Uid');

      // Construct the API URL with the user ID
      final String url = '${Custom_Config.BASE_URL}/wound/wounds/$userId';

      // Make the HTTP GET request
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      // Check for a successful response
      if (response.statusCode == 200) {
        // Parse the JSON response body into a list of FollowUp objects
        List<dynamic> responseBody = jsonDecode(response.body);
        List<FollowUp> followUps = responseBody
            .map((dynamic item) => FollowUp.fromJson(item))
            .toList();
        return followUps;
      } else {
        // Handle non-successful response
        throw Exception('Failed to load follow-ups: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle exceptions
      throw Exception('An error occurred while fetching follow-ups: $e');
    }
  }

  Future<List<FollowUp>> nursefetchFollowUps(String patientId) async {
    try {
      final String url = '${Custom_Config.BASE_URL}/wound/wounds/$patientId';
      print(patientId);
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> responseBody = jsonDecode(response.body);
        List<FollowUp> followUps = responseBody
            .map((dynamic item) => FollowUp.fromJson(item))
            .toList();
        return followUps;
      } else {
        // Handle non-successful response
        throw Exception('Failed to load follow-ups: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle exceptions
      throw Exception('An error occurred while fetching follow-ups: $e');
    }
  }
}

import 'package:mobile_app_decubitus/models/user_profile_model.dart'; // Import new model
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_app_decubitus/config/config.dart';
import 'auth_service.dart';

class UserProfileService {
  var logger = Logger();

  Future<userpf> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('Uid'); // Retrieve user ID
      final response = await http.get(
        Uri.parse('${Custom_Config.BASE_URL}/users/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}"
        },
      );
      logger.t(response.body);
      logger.t(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return userpf.fromJson(data); // Parse the response into userpf
      } else {
        logger.e('Status code error: ${response.statusCode}');
        throw Exception('Failed to fetch user profile: ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e.toString());
      throw Exception('Error fetching user profile: $e');
    }
  }

  Future<void> updateUserProfile(
      String id, Map<String, dynamic> updatedData) async {
    try {
      logger.i('Sending data: $updatedData'); // Log the data being sent
      final response = await http.patch(
        Uri.parse('${Custom_Config.BASE_URL}/users/profile/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await AuthService().getAccessToken()}"
        },
        body: json.encode(updatedData),
      );
      logger.t('Request body: ${json.encode(updatedData)}');
      logger.t('Response body: ${response.body}');
      logger.t('Response status code: ${response.statusCode}');
      if (response.statusCode == 400) {
        final errorResponse = json.decode(response.body);
        final errorMessage = errorResponse['message'] ?? 'Unknown error';
        logger.e('Error: $errorMessage');
        throw Exception(errorMessage);
      } else if (response.statusCode != 200 && response.statusCode != 204) {
        logger.e('Status code error: ${response.statusCode}');
        throw Exception(
            'Failed to update user profile: ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e.toString());
      throw Exception('$e');
    }
  }

  Future<String?> uploadImageFromPath(String filePath) async {
    try {
      final url = Uri.parse(
          '${Custom_Config.BASE_URL}/upload/file'); // Use baseUrl for the endpoint
      final request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath('file', filePath),
      );

      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final resBody = await response.stream.bytesToString();
        final data = jsonDecode(resBody);
        return data[
            'path']; // Assuming the backend returns the file path in 'path'
      } else {
        print("Failed to upload image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}

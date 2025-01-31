import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app_decubitus/models/wound_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class WoundService {
  final String baseUrl;
  var logger = Logger();

  WoundService(this.baseUrl);

  Future<List<Wound>> fetchOldWounds(int patinetId, String area) async {
    final url = '$baseUrl/wound/wounds/$patinetId/$area'; // Construct the URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Wound.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load old wounds: ${response.body}');
    }
  }

  Future<int?> createWound(Wound wound) async {
    final url = '$baseUrl/wound/create'; // Endpoint for creating a wound
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(wound.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['wound']?['id']; // Return the wound ID
    } else {
      throw Exception('Failed to create wound: ${response.body}');
    }
  }

  Future<List<WoundGroup>> fetchGroupedWounds(int perusalId) async {
    final url = '$baseUrl/wound/wounds/grouped/$perusalId';
    print('Fetching wounds from: $url'); // Log the URL being fetched

    final response = await http.get(Uri.parse(url));

    print('Response status: ${response.statusCode}'); // Log the response status
    print('Response body: ${response.body}'); // Log the response body

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      // Return a list of WoundGroup objects
      return jsonResponse.map((json) => WoundGroup.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load grouped wounds');
    }
  }

  Future<String?> uploadImageFromPath(String filePath) async {
    try {
      final url =
          Uri.parse('$baseUrl/upload/file'); // Use baseUrl for the endpoint
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

  Future<int?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('Uid'); // Retrieve the user ID as a String

    logger.t(id); // Log the retrieved ID

    return id != null ? int.tryParse(id) : null;
  }

  Future<void> deleteWound(int woundId) async {
    final url = '$baseUrl/wound/$woundId'; // API endpoint to delete a wound
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 204) {
      // Successfully deleted the wound
      print("Wound with ID $woundId deleted successfully.");
    } else {
      throw Exception('Failed to delete wound: ${response.body}');
    }
  }
}

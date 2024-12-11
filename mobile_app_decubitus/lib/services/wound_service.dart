import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app_decubitus/models/wound_model.dart';

class WoundService {
  final String baseUrl;

  WoundService(this.baseUrl);

  Future<List<WoundGroup>> fetchGroupedWounds(int perusalId) async {
    final url = '$baseUrl/wound/wounds/grouped/$perusalId';
    print('Fetching wounds from: $url'); // Log the URL being fetched

    final response = await http.get(Uri.parse(url));

    print('Response status: ${response.statusCode}'); // Log the response status
    print('Response body: ${response.body}'); // Log the response body

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
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
}

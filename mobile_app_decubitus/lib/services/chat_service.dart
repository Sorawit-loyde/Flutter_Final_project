import 'dart:convert';
import 'package:mobile_app_decubitus/models/chat_model.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import 'auth_service.dart';

class ChatService {
  final Logger logger = Logger();

  Future<List<Chat>> getChats() async {
    try {
      const roomId = 1; // Mock room ID
      logger.i('Fetching chats for room ID: $roomId');

      final String? accessToken = await AuthService().getAccessToken();
      final Uri uri = Uri.parse('${Custom_Config.BASE_URL}/chats/$roomId');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      logger.d('Response status: ${response.statusCode}');
      logger.d('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonData = json.decode(response.body);
        final chatResponse = ChatResponse.fromJson(jsonData);
        return chatResponse.data;
      } else {
        logger.e('Unexpected status code: ${response.statusCode}');
        throw Exception(
            'Failed to fetch chats: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching chats: $e', error: e, stackTrace: stackTrace);
      throw Exception('Failed to fetch chats. Please try again later.');
    }
  }

  Future<String?> uploadImageFromPath(String filePath) async {
  try {
    final url = Uri.parse('${Custom_Config.BASE_URL}/upload/file'); // Replace with your backend endpoint
    final request = http.MultipartRequest('POST', url);
    request.files.add(
      await http.MultipartFile.fromPath('file', filePath),
    );

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final resBody = await response.stream.bytesToString();
      final data = jsonDecode(resBody);
      // logger.i(data['path']);
      return data['path']; // Assuming the backend returns the file path in 'path'
    } else {
      logger.e("Failed to upload image: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    logger.e("Error uploading image: $e");
    return null;
  }
}

}

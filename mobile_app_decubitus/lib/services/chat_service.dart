import 'dart:convert';
import 'package:mobile_app_decubitus/models/chat_model.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import 'auth_service.dart';

class ChatService {
  final Logger logger = Logger();

  Future<List<Chat>> getChats(int roomId) async {
    try {
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
      final url = Uri.parse(
          '${Custom_Config.BASE_URL}/upload/file'); // Replace with your backend endpoint
      final request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath('file', filePath),
      );

      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final resBody = await response.stream.bytesToString();
        final data = jsonDecode(resBody);
        // logger.i(data['path']);
        return data[
            'path']; // Assuming the backend returns the file path in 'path'
      } else {
        logger.e("Failed to upload image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      logger.e("Error uploading image: $e");
      return null;
    }
  }

  Future<List<dynamic>> getWoundsFromPerusal(int roomId) async {
    try {
      // Fetch perusal_id
      final Uri perusalUri =
          Uri.parse('${Custom_Config.BASE_URL}/rooms/perusal/$roomId');
      final perusalResponse = await http.get(perusalUri);

      if (perusalResponse.statusCode != 200) {
        throw Exception('Failed to fetch perusal ID');
      }

      final perusalData = jsonDecode(perusalResponse.body);
      final int perusalId = perusalData['perusal_id'];

      // Fetch wounds data using perusalId
      final Uri woundsUri = Uri.parse(
          '${Custom_Config.BASE_URL}/wound/wounds/grouped/$perusalId');
      final woundsResponse = await http.get(woundsUri);

      if (woundsResponse.statusCode != 200) {
        throw Exception('Failed to fetch wounds data');
      }

      final woundsData = jsonDecode(woundsResponse.body) as List<dynamic>;
      return woundsData;
    } catch (e, stackTrace) {
      logger.e('Error fetching wounds data: $e',
          error: e, stackTrace: stackTrace);
      throw Exception('Failed to fetch wounds data. Please try again later.');
    }
  }

  Future<List<dynamic>> getWoundFollowup(int woundId) async {
    try {
      final Uri followupUri =
          Uri.parse('${Custom_Config.BASE_URL}/wound/followup/$woundId');
      final followupResponse = await http.get(followupUri);

      if (followupResponse.statusCode != 200) {
        throw Exception('Failed to fetch wound follow-up data');
      }

      final followupData = jsonDecode(followupResponse.body) as List<dynamic>;
      return followupData;
    } catch (e, stackTrace) {
      logger.e('Error fetching wound follow-up data: $e',
          error: e, stackTrace: stackTrace);
      throw Exception(
          'Failed to fetch wound follow-up data. Please try again later.');
    }
  }
}

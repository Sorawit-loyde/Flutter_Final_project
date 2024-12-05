import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';
import 'package:logger/logger.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/models/chat_model.dart';
import 'package:mobile_app_decubitus/services/chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Chatroom extends StatefulWidget {
  final int roomId; // Room ID to join
  const Chatroom({required this.roomId, super.key});

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  late ChatController chatController;
  WebSocketChannel? channel;
  final ChatService chatService = ChatService();
  bool isLoading = true;
  String? currentUserId;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _getCurrentUserId();
    await _connectToWebSocket();
    await loadChatHistory();
    _joinRoom();
  }

  Future<void> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('Uid');
    });
  }

  Future<void> _connectToWebSocket() async {
    const websocketUrl =
        Custom_Config.WebSocket_URL; // Replace with your WebSocket server URL
    channel = WebSocketChannel.connect(Uri.parse(websocketUrl));

    // Listen for incoming messages
    channel?.stream.listen((event) {
      final Map<String, dynamic> data = jsonDecode(event);
      final String eventType = data['event'];
      if (eventType == 'text' || eventType == 'image') {
        _handleIncomingMessage(data);
      }
    });
  }

  Future<void> loadChatHistory() async {
    try {
      List<Chat> chatData = await chatService.getChats();

      List<Message> messageList = chatData.map((chat) {
        MessageType messageType =
            chat.messageType == "image" ? MessageType.image : MessageType.text;

        return Message(
          id: chat.id.toString(),
          message: messageType == MessageType.image
              ? '${Custom_Config.Image_URL}/${chat.imageUrl}'
              : chat.message ?? "",
          createdAt: chat.createdAt,
          sentBy: chat.sender.id.toString(),
          messageType: messageType,
        );
      }).toList();

      chatController = ChatController(
        initialMessageList: messageList,
        scrollController: ScrollController(),
        currentUser: ChatUser(id: currentUserId ?? 'me', name: 'You'),
        otherUsers: chatData
            .map((chat) => ChatUser(
                  id: chat.sender.id.toString(),
                  name: chat.sender.fullname,
                ))
            .toSet()
            .toList(),
      );

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      debugPrint("Error loading chat history: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _joinRoom() {
    final joinRoomData = {
      'roomId': widget.roomId,
      'userId': currentUserId,
    };
    logger.i(joinRoomData);
    channel?.sink.add(jsonEncode({
      'event': 'joinRoom',
      'data': joinRoomData,
    }));
  }

  void _handleIncomingMessage(Map<String, dynamic> data) {
    logger.i(data);
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: data['event'] == 'image' ? '${Custom_Config.Image_URL}/${data['image']}' : data['message'],
      createdAt: DateTime.now(),
      sentBy: data['sendId'].toString(),
      messageType:
          data['event'] == 'image' ? MessageType.image : MessageType.text,
    );

    chatController.addMessage(newMessage);
  }

  void sendMessage(String? messageText,
      {String? imageUrl, MessageType messageType = MessageType.text}) {
    final messagePayload = <String, dynamic>{
      'roomId': widget.roomId,
      'sendId': currentUserId,
      'message': messageType == MessageType.text ? messageText : null,
      'imageUrl': messageType == MessageType.image ? imageUrl : null,
      'messageType': messageType == MessageType.image ? 'image' : 'text',
    };

    // Debug log to verify the payload
    debugPrint('Sending message payload: ${jsonEncode(messagePayload)}');

    channel?.sink.add(jsonEncode({
      'event': 'sendMessage',
      'data': messagePayload,
    }));
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Chatroom")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ChatView(
              appBar: const ChatViewAppBar(
                chatTitle: "Chatroom",
              ),
              chatController: chatController,
              onSendTap: (messageText, replyMessage, messageType) async {
                if (messageType == MessageType.text) {
                  sendMessage(messageText);
                } else if (messageType == MessageType.image) {
                  // The messageText contains the file path for the selected image
                  String? imageUrl =
                      await chatService.uploadImageFromPath(messageText);
                  if (imageUrl != null) {
                    sendMessage(null,
                        imageUrl: imageUrl, messageType: MessageType.image);
                  }
                }
              },
              chatViewState: chatController.initialMessageList.isNotEmpty
                  ? ChatViewState.hasMessages
                  : ChatViewState.noData,
              sendMessageConfig: const SendMessageConfiguration(
                enableGalleryImagePicker: true,
                enableCameraImagePicker: true,
                allowRecordingVoice: false,
                textFieldConfig: TextFieldConfiguration(
                  textStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
    );
  }
}

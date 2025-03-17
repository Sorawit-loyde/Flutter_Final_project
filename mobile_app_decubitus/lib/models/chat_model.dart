class Chat {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? message;
  final String messageType;
  final String? imageUrl;
  final Sender sender;

  const Chat({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.message,
    required this.messageType,
    this.imageUrl,
    required this.sender,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      message: json['message'] as String?,
      messageType: json['messageType'] as String,
      imageUrl: json['imageUrl'] as String?,
      sender: Sender.fromJson(json['sender'] as Map<String, dynamic>),
    );
  }
}

class Sender {
  final int id;
  final String fullname;

  const Sender({
    required this.id,
    required this.fullname,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'] as int,
      fullname: json['fullname'] as String,
    );
  }
}

class ChatResponse {
  final List<Chat> data;

  const ChatResponse({
    required this.data,
  });

  factory ChatResponse.fromJson(List<dynamic> jsonList) {
    List<Chat> chats = jsonList.map((item) => Chat.fromJson(item as Map<String, dynamic>)).toList();
    return ChatResponse(data: chats);
  }
}
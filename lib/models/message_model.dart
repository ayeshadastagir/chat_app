class MessageModel {
  final String? id;
  final String senderId;
  final String chatroomId;
  final String content;
  final DateTime createdAt;

  MessageModel({
    this.id,
    required this.senderId,
    required this.chatroomId,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toLocal();

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'], // Include id from database
      senderId: json['sender_id'] ?? '',
      chatroomId: json['chatroom_id'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at']).toLocal()
          : DateTime.now().toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'sender_id': senderId,
      'chatroom_id': chatroomId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };

    // Only include id if it's not null (for updates)
    if (id != null) {
      json['id'] = id;
    }

    return json;
  }
}
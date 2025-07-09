class ChatRoomModel {
  final String? id;
  final String senderId;
  final String receiverId;
  final DateTime createdAt;

  ChatRoomModel({
    this.id,
    required this.senderId,
    required this.receiverId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toLocal();

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'], // Include id from database
      senderId: json.containsKey('sender_id') ? json['sender_id'] ?? '' : '',
      receiverId: json.containsKey('receiver_id') ? json['receiver_id'] ?? '' : '',
      createdAt: json.containsKey('created_at') && json['created_at'] != null
          ? DateTime.parse(json['created_at']).toLocal()
          : DateTime.now().toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'created_at': createdAt.toIso8601String(),
    };

    // Only include id if it's not null (for updates)
    if (id != null) {
      json['id'] = id;
    }

    return json;
  }
}
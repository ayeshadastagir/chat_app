import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_tables.dart';
import '../models/chat_room_model.dart';

class ChatRoomService {
  static final ChatRoomService _instance = ChatRoomService._internal();
  factory ChatRoomService() => _instance;
  ChatRoomService._internal();

  static ChatRoomService get instance => _instance;

  final SupabaseClient _client = Supabase.instance.client;

  /// Get existing chatroom between two users or create a new one
  Future<String> getOrCreateChatroom(String currentUserID, String otherUserID) async {
    try {
      // First, check if chatroom already exists (either direction)
      final existingChatroom = await _client
          .from(SupabaseTables.chatroom)
          .select()
          .or('and(sender_id.eq.$currentUserID,receiver_id.eq.$otherUserID),and(sender_id.eq.$otherUserID,receiver_id.eq.$currentUserID)')
          .maybeSingle();

      if (existingChatroom != null) {
        return existingChatroom['id'];
      } else {
        ChatRoomModel model = ChatRoomModel(senderId: currentUserID, receiverId: otherUserID);
        final response = await _client
            .from(SupabaseTables.chatroom)
            .insert(model.toJson())
            .select()
            .single();

        return response['id'];
      }
    } catch (e) {
      throw Exception('Failed to get or create chatroom: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserRecentChats(String userID) async {
    try {
      // 1. Get all chatRooms where user is sender or receiver
      final response = await _client
          .from(SupabaseTables.chatroom)
          .select('id, sender_id, receiver_id')
          .or('sender_id.eq.$userID,receiver_id.eq.$userID')
          .order('created_at', ascending: false);

      final chatrooms = response as List;

      // 2. For each chatroom, fetch last message + other user’s profile
      List<Map<String, dynamic>> result = [];

      for (var chat in chatrooms) {
        final chatroomId = chat['id'];
        final senderId = chat['sender_id'];
        final receiverId = chat['receiver_id'];
        final otherUserId = senderId == userID ? receiverId : senderId;

        // Get other user profile
        final profile = await _client
            .from(SupabaseTables.userProfile)
            .select('username, email')
            .eq('id', otherUserId)
            .maybeSingle();

        // Get last message
        final lastMessage = await _client
            .from(SupabaseTables.messages)
            .select()
            .eq('chatroom_id', chatroomId)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();

        result.add({
          'chatroom_id': chatroomId,
          'other_user_id': otherUserId,
          'other_username': profile?['username'] ?? 'User',
          'other_email': profile?['email'] ?? '',
          'last_message': lastMessage?['content'],
          'last_time': lastMessage?['created_at'],
        });
      }

      return result;
    } catch (e) {
      throw Exception('Failed to get recent chats: $e');
    }
  }



/// Get chatroom details by ID
  // Future<ChatRoomModel?> getChatroomById(String chatroomId) async {
  //   try {
  //     final response = await _client
  //         .from(SupabaseTables.chatroom)
  //         .select()
  //         .eq('id', chatroomId)
  //         .maybeSingle();
  //
  //     if (response != null) {
  //       return ChatRoomModel.fromJson(response);
  //     }
  //     return null;
  //   } catch (e) {
  //     throw Exception('Failed to get chatroom: $e');
  //   }
  // }

  /// Get all chatrooms for a user
  // Future<List<ChatRoomModel>> getUserChatrooms(String userID) async {
  //   try {
  //     final response = await _client
  //         .from(SupabaseTables.chatroom)
  //         .select()
  //         .or('sender_id.eq.$userID,receiver_id.eq.$userID')
  //         .order('created_at', ascending: false);
  //
  //     return (response as List)
  //         .map((json) => ChatRoomModel.fromJson(json))
  //         .toList();
  //   } catch (e) {
  //     throw Exception('Failed to get user chatrooms: $e');
  //   }
  // }

  /// Delete a chatroom
  // Future<void> deleteChatroom(String chatroomId) async {
  //   try {
  //     await _client
  //         .from(SupabaseTables.chatroom)
  //         .delete()
  //         .eq('id', chatroomId);
  //   } catch (e) {
  //     throw Exception('Failed to delete chatroom: $e');
  //   }
  // }
}
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_tables.dart';
import '../models/message_model.dart';

class MessageService {
  static final MessageService _instance = MessageService._internal();
  factory MessageService() => _instance;
  MessageService._internal();

  static MessageService get instance => _instance;

  final SupabaseClient _client = Supabase.instance.client;

  /// Send a new message
  Future<void> sendMessage({
    required String senderId,
    required String chatroomId,
    required String content,
  }) async {
    try {
      MessageModel model = MessageModel(senderId: senderId, chatroomId: chatroomId, content: content);
      await _client
          .from(SupabaseTables.messages)
          .insert(model.toJson());
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Get all messages for a chatroom
  Future<List<MessageModel>> getChatroomMessages(String chatroomId) async {
    try {
      final response = await _client
          .from(SupabaseTables.messages)
          .select()
          .eq('chatroom_id', chatroomId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => MessageModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load messages: $e');
    }
  }

  /// Get recent messages for a chatroom (with limit)
  // Future<List<MessageModel>> getRecentMessages(String chatroomId, {int limit = 50}) async {
  //   try {
  //     final response = await _client
  //         .from(SupabaseTables.messages)
  //         .select()
  //         .eq('chatroom_id', chatroomId)
  //         .order('created_at', ascending: false)
  //         .limit(limit);
  //
  //     final messages = (response as List)
  //         .map((json) => MessageModel.fromJson(json))
  //         .toList();
  //
  //     // Reverse to show oldest first
  //     return messages.reversed.toList();
  //   } catch (e) {
  //     throw Exception('Failed to load recent messages: $e');
  //   }
  // }

  /// Delete a message
  // Future<void> deleteMessage(String messageId) async {
  //   try {
  //     await _client
  //         .from(SupabaseTables.messages)
  //         .delete()
  //         .eq('id', messageId);
  //   } catch (e) {
  //     throw Exception('Failed to delete message: $e');
  //   }
  // }

  // /// Update message content
  // Future<void> updateMessage(String messageId, String newContent) async {
  //   try {
  //     await _client
  //         .from(SupabaseTables.messages)
  //         .update({'content': newContent})
  //         .eq('id', messageId);
  //   } catch (e) {
  //     throw Exception('Failed to update message: $e');
  //   }
  // }

  /// Get message by ID
  // Future<MessageModel?> getMessageById(String messageId) async {
  //   try {
  //     final response = await _client
  //         .from(SupabaseTables.messages)
  //         .select()
  //         .eq('id', messageId)
  //         .maybeSingle();
  //
  //     if (response != null) {
  //       return MessageModel.fromJson(response);
  //     }
  //     return null;
  //   } catch (e) {
  //     throw Exception('Failed to get message: $e');
  //   }
  // }

  /// Get messages count for a chatroom
  // Future<int> getMessagesCount(String chatroomId) async {
  //   try {
  //     final response = await _client
  //         .from(SupabaseTables.messages)
  //         .select('id')
  //         .eq('chatroom_id', chatroomId)
  //         .count();
  //
  //     return response.count;
  //   } catch (e) {
  //     throw Exception('Failed to get messages count: $e');
  //   }
  // }
}
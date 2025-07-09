import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message_model.dart';

class RealtimeService {
  static final RealtimeService _instance = RealtimeService._internal();
  factory RealtimeService() => _instance;
  RealtimeService._internal();
  static RealtimeService get instance => _instance;

  final SupabaseClient _client = Supabase.instance.client;
  final Map<String, RealtimeChannel> _subscriptions = {};

  /// Subscribe to new messages in a chatroom
  RealtimeChannel subscribeToMessages({
    required String chatroomId,
    required Function(MessageModel) onMessageReceived,
  }) {
    final channelName = 'messages:$chatroomId';

    // Unsubscribe if already subscribed
    if (_subscriptions.containsKey(channelName)) {
      _subscriptions[channelName]?.unsubscribe();
    }

    final channel = _client
        .channel(channelName)
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'chatroom_id',
        value: chatroomId,
      ),
      callback: (payload) {
        final newMessage = MessageModel.fromJson(payload.newRecord);
        onMessageReceived(newMessage);
      },
    )
        .subscribe();

    _subscriptions[channelName] = channel;
    return channel;
  }


  /// Subscribe to message updates (for edit/delete functionality)
  // RealtimeChannel subscribeToMessageUpdates({
  //   required String chatroomId,
  //   required Function(MessageModel) onMessageUpdated,
  //   required Function(String messageId) onMessageDeleted,
  // }) {
  //   final channelName = 'message_updates:$chatroomId';
  //
  //   // Unsubscribe if already subscribed
  //   if (_subscriptions.containsKey(channelName)) {
  //     _subscriptions[channelName]?.unsubscribe();
  //   }
  //
  //   final channel = _client
  //       .channel(channelName)
  //       .onPostgresChanges(
  //     event: PostgresChangeEvent.update,
  //     schema: 'public',
  //     table: 'messages',
  //     filter: PostgresChangeFilter(
  //       type: PostgresChangeFilterType.eq,
  //       column: 'chatroom_id',
  //       value: chatroomId,
  //     ),
  //     callback: (payload) {
  //       final updatedMessage = MessageModel.fromJson(payload.newRecord);
  //       onMessageUpdated(updatedMessage);
  //     },
  //   )
  //       .onPostgresChanges(
  //     event: PostgresChangeEvent.delete,
  //     schema: 'public',
  //     table: 'messages',
  //     filter: PostgresChangeFilter(
  //       type: PostgresChangeFilterType.eq,
  //       column: 'chatroom_id',
  //       value: chatroomId,
  //     ),
  //     callback: (payload) {
  //       final messageId = payload.oldRecord['id'];
  //       onMessageDeleted(messageId);
  //     },
  //   )
  //       .subscribe();
  //
  //   _subscriptions[channelName] = channel;
  //   return channel;
  // }

  /// Subscribe to chatroom changes
  // RealtimeChannel subscribeToChatroomChanges({
  //   required String userId,
  //   required Function() onChatroomChanged,
  // }) {
  //   final channelName = 'chatroom_changes:$userId';
  //
  //   // Unsubscribe if already subscribed
  //   if (_subscriptions.containsKey(channelName)) {
  //     _subscriptions[channelName]?.unsubscribe();
  //   }
  //
  //   final channel = _client
  //       .channel(channelName)
  //       .onPostgresChanges(
  //     event: PostgresChangeEvent.insert,
  //     schema: 'public',
  //     table: 'chatroom',
  //     filter: PostgresChangeFilter(
  //       type: PostgresChangeFilterType.eq,
  //       column: 'sender_id.eq.$userId,receiver_id.eq.$userId',
  //       value: '',
  //     ),
  //     callback: (payload) => onChatroomChanged(),
  //   )
  //       .subscribe();
  //
  //   _subscriptions[channelName] = channel;
  //   return channel;
  // }

  // /// Unsubscribe from a specific channel
  // void unsubscribe(String channelName) {
  //   if (_subscriptions.containsKey(channelName)) {
  //     _subscriptions[channelName]?.unsubscribe();
  //     _subscriptions.remove(channelName);
  //   }
  // }

  /// Unsubscribe from all channels
  // void unsubscribeAll() {
  //   for (final channel in _subscriptions.values) {
  //     channel.unsubscribe();
  //   }
  //   _subscriptions.clear();
  // }
  //
  // /// Get active subscription count
  // int get activeSubscriptions => _subscriptions.length;

  /// Check if subscribed to a channel
  // bool isSubscribed(String channelName) {
  //   return _subscriptions.containsKey(channelName);
  // }
}
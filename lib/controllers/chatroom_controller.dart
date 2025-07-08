import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message_model.dart';
import '../services/auth_service.dart';
import '../services/chat_room_service.dart';
import '../services/message_service.dart';
import '../services/real_time_service.dart';

class ChatRoomController extends GetxController {
  late final String id;
  late final String email;
  late final String name;
  final currentUserID = AuthService.instance.currentUserID;

  // Text controller for message input
  final TextEditingController messageController = TextEditingController();

  // Observable variables
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;

  // Current chatroom ID
  String? _chatroomId;

  // Services
  final ChatRoomService _chatroomService = ChatRoomService.instance;
  final MessageService _messageService = MessageService.instance;
  final RealtimeService _realtimeService = RealtimeService.instance;

  // Realtime subscription
  RealtimeChannel? _messageSubscription;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    id = args['id'];
    email = args['email'];
    name = args['name'];

    _initializeChatroom();
  }

  @override
  void onClose() {
    messageController.dispose();
    _messageSubscription?.unsubscribe();
    super.onClose();
  }

  Future<void> _initializeChatroom() async {
    isLoading.value = true;
    try {
      // Get or create chatroom
      _chatroomId = await _chatroomService.getOrCreateChatroom(currentUserID, id);

      // Load existing messages
      await _loadMessages();

      // Subscribe to realtime messages
      _subscribeToMessages();
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize chatroom: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadMessages() async {
    if (_chatroomId == null) return;

    try {
      final messageList = await _messageService.getChatroomMessages(_chatroomId!);
      messages.value = messageList;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages: $e');
    }
  }

  void _subscribeToMessages() {
    if (_chatroomId == null) return;

    _messageSubscription = _realtimeService.subscribeToMessages(
      chatroomId: _chatroomId!,
      onMessageReceived: (MessageModel newMessage) {
        messages.add(newMessage);
      },
    );
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty || _chatroomId == null) return;

    isSending.value = true;
    try {
      await _messageService.sendMessage(
        senderId: currentUserID,
        chatroomId: _chatroomId!,
        content: messageController.text.trim(),
      );

      messageController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
    } finally {
      isSending.value = false;
    }
  }

  bool isMyMessage(MessageModel message) {
    return message.senderId == currentUserID;
  }

  String formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/chat_room_service.dart';

class RecentChatsController extends GetxController {
  final chatRoom = [].obs;
  final isLoading = false.obs;
  final String currentUserID = AuthService.instance.currentUserID;
  final ChatRoomService _chatRoomService = ChatRoomService.instance;

  RealtimeChannel? _messageChannel;

  @override
  void onInit() {
    super.onInit();
    fetchRecentChats();
    setupRealtimeListener();
  }

  Future<void> fetchRecentChats() async {
    isLoading.value = true;
    try {
      final data = await _chatRoomService.getUserRecentChats(currentUserID);

      // Sort by last_time (descending)
      data.sort((a, b) {
        final timeA = DateTime.tryParse(a['last_time'] ?? '') ?? DateTime(1970);
        final timeB = DateTime.tryParse(b['last_time'] ?? '') ?? DateTime(1970);
        return timeB.compareTo(timeA); // Most recent first
      });

      chatRoom.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load recent chats: $e');
      print('❌ Error: $e');
    } finally {
      isLoading.value = false;
    }
  }


  void setupRealtimeListener() {
    final client = Supabase.instance.client;

    _messageChannel = client.channel('public:messages')
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'messages',
        callback: (payload) {
          print('📥 New message: ${payload.newRecord}');
          fetchRecentChats(); // Refresh chat list
        },
      )
      ..subscribe();
  }

  @override
  void onClose() {
    _messageChannel?.unsubscribe();
    super.onClose();
  }
}

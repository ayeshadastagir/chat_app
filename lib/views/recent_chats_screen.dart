import 'package:chat_app/views/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recent_chats_controller.dart';
import 'chat_room_screen.dart';

class RecentChatsScreen extends StatelessWidget {
  RecentChatsScreen({super.key});

  final RecentChatsController controller = Get.put(RecentChatsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xff898AC4),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Recent Chats',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.chatRoom.isEmpty) {
          return const Center(child: Text('No recent chats'));
        }

        return ListView.builder(
          itemCount: controller.chatRoom.length,
          itemBuilder: (context, index) {
            final chat = controller.chatRoom[index];
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xff898AC4),
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(chat['other_username']),
              subtitle: Text(
                chat['last_message'] ?? 'No messages yet',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                chat['last_time'] != null
                    ? _formatTime(DateTime.parse(chat['last_time']).toLocal())
                    : '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                Get.to(
                      () => ChatRoomScreen(),
                  arguments: {
                    'id': chat['other_user_id'],
                    'email': chat['other_email'],
                    'name': chat['other_username'],
                  },
                );
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAll(Home());
          // Example: start a new chat or go to user list screen
        },
        backgroundColor: const Color(0xff898AC4),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }
}

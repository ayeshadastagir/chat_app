import 'package:chat_app/controllers/home_controller.dart';
import 'package:chat_app/models/profile_model.dart';
import 'package:chat_app/views/chat_room_screen.dart';
import 'package:chat_app/widgets/chat_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Home extends StatelessWidget {
  Home({super.key});
  final HomeController controller = Get.put(HomeController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatAppBar(),
      body: FutureBuilder<List<ProfileModel>>(
        future: controller.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return const Center(child: Text("No other users found."));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(user.username),
                subtitle: Text(user.email),
                onTap: () {
                  // TODO: Navigate to chat screen with user
                  print("Tapped on: ${user.username}");
                  print("${user}");
                  Get.to(() => ChatRoomScreen(), arguments: {
                    'id': user.id,
                    'email': user.email,
                    'name': user.username,
                  });

                },
              );
            },
          );
        },
      ),
    );
  }
}

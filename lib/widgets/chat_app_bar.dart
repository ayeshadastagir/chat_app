import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  const ChatAppBar({super.key, this.text = "Chat" });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xff898AC4),
      elevation: 4,
      centerTitle: true,
      title: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
          onPressed: () async {
            await AuthService.instance.signOut();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

import 'package:chat_app/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../views/recent_chats_screen.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void handleSignup() async {
    if (formKey.currentState!.validate()) {
      try {
        await AuthService.instance.signupWithEmailPassword(
          emailController.text,
          passwordController.text,
          nameController.text,
        );
        _clearFields();
        Get.offAll(RecentChatsScreen());
        // AuthenticationService.instance.fetchUserData();
      } catch (e) {
        print("$e");
        // SnackbarHelper.show(
        //   title: "Signup Failed",
        //   message: 'Something went wrong during verification. Please try again. ${e}',
        //   type: SnackbarType.error,
        // );
      }
    }
  }
  _clearFields(){
    emailController.clear();
    passwordController.clear();
    nameController.clear();
  }

  void handleLogin() {
    // Navigate to login screen
    Get.offAll(() => LoginScreen());
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}

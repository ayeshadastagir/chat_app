import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/views/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/register_screen.dart';

// Login Controller
class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }

  void handleLogin() async {
    if (formKey.currentState!.validate()) {
      // print('Email: ${emailController.text}');
      // print('Password: ${passwordController.text}');
      try {
        await AuthService.instance.signInWithEmailPassword(
            emailController.text, passwordController.text);
       _clearFields();
        Get.offAll(Home());
      } catch (e) {
        print("$e");
      }
    }
  }

  _clearFields(){
    emailController.clear();
    passwordController.clear();
  }

  void handleSignup() {
    Get.offAll(() => RegisterScreen());
    // print('Navigate to register screen');
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
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}
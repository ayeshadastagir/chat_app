import 'package:chat_app/views/login_screen.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/supabase_tables.dart';
import '../models/profile_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  static AuthService get instance => _instance;

  AuthService._internal();

  final SupabaseClient _supabaseClient = Supabase.instance.client;

  User get currentUser => _supabaseClient.auth.currentUser!;

  String get currentUserID => _supabaseClient.auth.currentUser!.id;

  Future<void> signupWithEmailPassword(
    String email,
    String password,
    String username,
  ) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw Exception("Signup failed - user is null");
      }
      ProfileModel model = ProfileModel(
        id: user.id,
        username: username,
        email: email,
      );
      await _supabaseClient
          .from(SupabaseTables.userProfile)
          .insert(model.toJson());
    } catch (e) {
      throw Exception("Registration error: $e");
    }
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      final errorMessage = e.message.toLowerCase();
      if (errorMessage.contains("invalid login credentials") ||
          errorMessage.contains("invalid email or password")) {
        print("invalid login credentials");
      }
      throw Exception("Login error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected login error: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
      print ('signout successfull ');
      Get.offAll(LoginScreen());
    } catch (e) {
      print("Failed to clear Signout $e");
    }
  }
}

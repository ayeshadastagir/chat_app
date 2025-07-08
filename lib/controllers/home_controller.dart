import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/supabase_tables.dart';
import '../models/profile_model.dart';
import '../services/auth_service.dart';

class HomeController extends GetxController {
  final client = Supabase.instance.client;
  final currentUserID = AuthService.instance.currentUserID;

  Future<List<ProfileModel>> fetchUsers() async {
    final response = await client
        .from(SupabaseTables.userProfile)
        .select()
        .neq('id', currentUserID);

    return (response as List)
        .map((json) => ProfileModel.fromJson(json))
        .toList();
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';

class InitSupabaseUser {
  Future<User> getUserId() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }
    return user;
  }
}

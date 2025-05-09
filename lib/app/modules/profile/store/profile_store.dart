import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileStore {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> fetchProfile() async {
    final userId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from('user')
        .select('name, email')
        .eq('user_id', userId)
        .single();

    return response;
  }

  Future<void> updateProfile(String name, String email) async {
    final userId = supabase.auth.currentUser!.id;

    final response = await supabase.from('profiles').insert({
      'user_id': userId,
      'name': name,
      'email': email,
    });

    if (response.error != null) {
      throw Exception('Error updating profile');
    }
  }
}

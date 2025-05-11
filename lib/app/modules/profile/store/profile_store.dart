import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileStore {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> fetchProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final userId = user.id;
    Map<String, dynamic> mapProfile = {};
    String? email = user.email;

    // Buscar o nome e o caminho do avatar do usuário
    final response = await supabase
        .from("user_profiles")
        .select('name, avatar')
        .eq("user_id", userId)
        .single(); 

    String name = response['name'];
    String avatar = response['avatar'] ?? ''; // Caminho do avatar

    mapProfile = {'name': name, 'email': email, 'avatar': avatar };
    return mapProfile;
  }
}

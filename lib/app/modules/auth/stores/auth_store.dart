import 'package:supabase_flutter/supabase_flutter.dart';

class AuthStore {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> signIn(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception('Erro ao fazer login');
    }
  }

  Future<void> signUp(String email, String password) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception('Erro ao cadastrar');
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}

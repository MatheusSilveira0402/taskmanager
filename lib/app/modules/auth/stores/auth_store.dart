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

  Future<void> signUp(String email, String password, String name) async {
    try {
      // Realizando o cadastro do usuário
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Erro ao cadastrar: $response');
      }

      final user = response.user;
      final userId = user?.id;

      // Após o cadastro, vamos salvar informações extras na tabela user_profiles
      final profileResponse = await supabase.from('user_profiles').insert({
        'user_id': userId, // Chave do usuário
        'name': name, // Nome fornecido durante o cadastro
        'avatar': '', // Você pode deixar vazio ou adicionar um valor padrão
      });

      if (profileResponse != null) {
        throw Exception(
            'Erro ao salvar dados do perfil: ${profileResponse.error?.message}');
      }
    } catch (e) {
      throw Exception('Erro ao cadastrar o usuário. Tente novamente mais tarde.');
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}

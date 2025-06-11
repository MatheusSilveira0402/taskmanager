
import 'package:supabase_flutter/supabase_flutter.dart';

/// Store responsável pela autenticação e registro de usuários.
///
/// Utiliza o Supabase para realizar login, cadastro de usuários e armazenamento
/// de dados adicionais como nome e avatar.
class AuthStore {
  /// Cliente Supabase utilizado para chamadas de autenticação e acesso ao banco.
  final SupabaseClient supabase = Supabase.instance.client;

  /// Realiza login do usuário com e-mail e senha.
  ///
  /// Lança uma exceção se o login falhar ou o usuário não for retornado.
  Future<void> signIn(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Erro ao fazer login');
    }
  }

  /// Cadastra um novo usuário com e-mail, senha, nome e avatar (opcional).
  ///
  /// O processo inclui:
  /// 1. Criação da conta no Supabase Auth;
  /// 2. Upload do avatar (caso fornecido) no bucket `avatars`;
  /// 3. Inserção dos dados do perfil na tabela `user_profiles`;
  ///
  /// Lança uma exceção com mensagem descritiva em caso de erro.
  Future<void> signUp(String email, String password, String name, [String? avatar]) async {
    try {
      // Criação da conta
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      final user = response.user;

      if (user == null) {
        throw Exception('Erro ao cadastrar o usuário.');
      }

      // Pequeno atraso para garantir consistência
      await Future.delayed(const Duration(seconds: 1));

      // Insere dados do perfil na tabela user_profiles
      await supabase.from('user_profiles').insert({
        'user_id': user.id,
        'name': name,
        'avatar': avatar,
      });
    } catch (e) {
      throw Exception('Erro ao cadastrar o usuário: $e');
    }
  }
}

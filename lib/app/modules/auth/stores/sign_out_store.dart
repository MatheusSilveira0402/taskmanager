import 'package:supabase_flutter/supabase_flutter.dart';

/// A classe [SignOutStore] gerencia o processo de desconexão do usuário.
class SignOutStore {
  /// Instância do cliente Supabase para realizar operações de autenticação.
  final supabase = Supabase.instance.client;

  /// Desconecta o usuário atualmente autenticado.
  ///
  /// Este método utiliza a instância do Supabase para realizar o logout
  /// do usuário, encerrando a sessão ativa.
  Future<void> signOut() async {
    // Chama o método signOut da autenticação do Supabase.
    await supabase.auth.signOut();
  }
}

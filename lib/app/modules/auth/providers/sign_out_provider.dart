import 'package:flutter/material.dart';
import 'package:task_manager_app/app/modules/auth/stores/sign_out_store.dart';

/// Provider responsável por encapsular a lógica de deslogar (sign out) do usuário.
///
/// Este provider expõe um método [signOut] que delega a operação de logout
/// para o [SignOutStore]. Ele pode ser usado com `Provider` ou `ChangeNotifierProvider`
/// para permitir o consumo dessa lógica em widgets da interface.
class SignOutProvider extends ChangeNotifier {
  /// Instância do store que contém a lógica de autenticação e logout.
  final SignOutStore _store;

  /// Construtor que recebe o [SignOutStore] necessário para realizar o logout.
  SignOutProvider(this._store);

  /// Realiza o processo de logout do usuário.
  ///
  /// Este método apenas chama o método `signOut()` do [SignOutStore].
  /// Pode ser usado, por exemplo, ao clicar em um botão "Sair" na interface.
  Future<void> signOut() async {
    await _store.signOut();
  }
}

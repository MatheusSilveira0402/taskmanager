import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task_manager_app/app/modules/stats/store/profile_store.dart';

/// O `ProfileProvider` gerencia o estado do perfil do usuário, incluindo a
/// busca e atualização de informações como nome, e-mail e avatar.
///
/// Ele utiliza o `ProfileStore` para fazer a comunicação com o armazenamento
/// ou API para obter e atualizar os dados de perfil.
class ProfileProvider extends ChangeNotifier {
  final ProfileStore _store;

  // Construtor que recebe uma instância do ProfileStore
  ProfileProvider(this._store);

  // Variáveis que armazenam os dados do perfil
  String name = ''; // Nome do usuário
  String email = ''; // E-mail do usuário
  String avatar = ''; // URL ou caminho do avatar do usuário
  bool loading = false; // Indicador de carregamento durante as requisições

  /// Método assíncrono que busca as informações do perfil do usuário
  /// utilizando o `ProfileStore`.
  ///
  /// Ele define as variáveis de estado com os dados retornados e
  /// notifica os ouvintes para atualizar a UI.
  Future<void> fetchProfile() async {
    loading = true;
    notifyListeners();

    try {
      final profile = await _store.fetchProfile();
      name = profile['name'];
      email = profile['email'];
      avatar = profile['avatar'] ?? ''; // Se o avatar não existir, define como string vazia
    } catch (e) {
      print('Error fetching profile: $e'); // Exibe erro no console caso a requisição falhe
    }

    loading = false;
    notifyListeners();
  }

  /// Método assíncrono que permite a atualização do avatar do usuário.
  ///
  /// Ele usa o `ProfileStore` para fazer o upload e atualizar a imagem do avatar.
  Future<void> updateImageProfile(File avatar) async {
    await _store.uploadAndUpdateAvatar(avatar); // Atualiza o avatar no backend
  }
}

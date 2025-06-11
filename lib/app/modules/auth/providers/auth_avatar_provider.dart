import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_manager_app/app/modules/auth/stores/auth_avatar_store.dart';

/// O `AuthAvatarProvider` gerencia o estado do perfil do usuário, incluindo a
/// busca e atualização de informações como nome, e-mail e avatar.
///
/// Ele utiliza o `AuthAvatarStore` para fazer a comunicação com o armazenamento
/// ou API para obter e atualizar os dados de perfil.
class AuthAvatarProvider extends ChangeNotifier {
  final AuthAvatarStore _store;

  // Construtor que recebe uma instância do AuthAvatarStore
  AuthAvatarProvider(this._store);

  String? _pickedImage;
  String? get pickedImage => _pickedImage;

  // Variáveis que armazenam os dados do perfil
  String name = ''; // Nome do usuário
  String email = ''; // E-mail do usuário
  String avatar = ''; // URL ou caminho do avatar do usuário
  bool loading = false; // Indicador de carregamento durante as requisições

  /// Método assíncrono que busca as informações do perfil do usuário
  /// utilizando o `AuthAvatarStore`.
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
      avatar =
          profile['avatar'] ?? ''; // Se o avatar não existir, define como string vazia
    } catch (e) {
      debugPrint(
          'Error fetching profile: $e'); // Exibe erro no console caso a requisição falhe
    }

    loading = false;
    notifyListeners();
  }

  /// Método assíncrono que permite a atualização do avatar do usuário.
  ///
  /// Ele usa o `AuthAvatarStore` para fazer o upload e atualizar a imagem do avatar.
  // Permite que a própria UI abra o ImagePicker e já envie o resultado
  Future<void> pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked == null) return;

    final tempDir = await getTemporaryDirectory();
    final tempFile = await File('${tempDir.path}/avatar_temp.png')
        .writeAsBytes(await picked.readAsBytes());

    loading = true;
    notifyListeners();

    try {
      final url = await _store.uploadAndUpdateAvatar(tempFile);
      avatar = url;
      _pickedImage = url;
    } catch (e, s) {
      debugPrint('Erro no upload do avatar: $e\n$s');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}

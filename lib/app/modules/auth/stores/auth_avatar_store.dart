import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager_app/app/core/init_supabase_user.dart';

/// O `AuthAvatarStore` é responsável por interagir com a base de dados do Supabase
/// para buscar e atualizar o perfil do usuário, incluindo o nome, email e avatar.
class AuthAvatarStore {
  final supabase = Supabase.instance.client;

  /// Método assíncrono que busca as informações do perfil do usuário autenticado,
  /// incluindo nome, email e avatar.
  ///
  /// Retorna um `Map<String, dynamic>` com as informações do perfil.
  /// Se o usuário não estiver autenticado, lança uma exceção.
  Future<Map<String, dynamic>> fetchProfile() async {
    // Obtém o ID do usuário autenticado
    final user = await InitSupabaseUser().getUserId();

    final userId = user.id;
    Map<String, dynamic> mapProfile = {};
    String? email = user.email;

    // Busca o nome e o caminho do avatar do usuário na tabela 'user_profiles'
    final response = await supabase
        .from("user_profiles")
        .select('name, avatar')
        .eq("user_id", userId)
        .single();

    String name = response['name'];
    String avatar = response['avatar'] ?? ''; // Caminho do avatar, ou string vazia caso não haja

    // Preenche o mapa de perfil
    mapProfile = {'name': name, 'email': email, 'avatar': avatar};
    return mapProfile;
  }

  /// Método assíncrono que faz o upload de uma nova imagem de avatar para o Supabase
  /// e atualiza o perfil do usuário com a URL pública do novo avatar.
  ///
  /// Retorna a URL pública do avatar após o upload.
  Future<String> uploadAndUpdateAvatar(File avatar) async {
    // Obtém o ID do usuário autenticado
    final user = await InitSupabaseUser().getUserId();
    final userId = user.id;
    try {
      // Nome do arquivo do avatar, baseado no ID do usuário
      final fileName = '$userId.jpg';

      // Remove o avatar antigo, se houver
      await supabase.storage.from('avatars').remove([fileName]);

      // Faz o upload do novo avatar
      final uploadResponse = await supabase.storage
          .from('avatars')
          .upload(fileName, avatar);

      // Verifica se o upload foi bem-sucedido
      if (!uploadResponse.contains(fileName)) {
        throw Exception('Falha ao fazer upload do avatar.');
      }

      // Obtém a URL pública do avatar
      final publicUrl = supabase.storage.from('avatars').getPublicUrl(fileName);

      // Atualiza o avatar no perfil do usuário na tabela 'user_profiles'
      await supabase
          .from('user_profiles')
          .update({'avatar': publicUrl}).eq('user_id', userId);

      return publicUrl;
    } catch (e) {
      throw Exception('Erro ao fazer upload do avatar: $e');
    }
  }
}

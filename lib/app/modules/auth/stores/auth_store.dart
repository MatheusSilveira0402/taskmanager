import 'dart:io';

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

  Future<void> signUp(String email, String password, String name, [File? avatar]) async {
    try {
      // Cria o usuário
      final response = await supabase.auth.signUp(email: email, password: password);
      final user = response.user;

      if (user == null) {
        throw Exception('Erro ao cadastrar o usuário.');
      }

      // Aguarda brevemente para garantir que o usuário foi persistido no banco
      await Future.delayed(const Duration(seconds: 1));

      String avatarUrl = '';

      // Se houver avatar, faz upload
      if (avatar != null) {
        final fileName = '${user.id}.jpg';

        final storageResponse =
            await supabase.storage.from('avatars').upload(fileName, avatar);

        if (!storageResponse.contains('avatars')) {
          throw Exception(
              'Erro ao fazer upload do avatar: $storageResponse');
        }

        final urlResponse = supabase.storage.from('avatars').getPublicUrl(fileName);
        avatarUrl = urlResponse;
      }

      // Salva os dados do perfil
      await supabase.from('user_profiles').insert({
        'user_id': user.id,
        'name': name,
        'avatar': avatarUrl,
      });
    } catch (e) {
      throw Exception('Erro ao cadastrar o usuário: $e');
    }
  }

  
}

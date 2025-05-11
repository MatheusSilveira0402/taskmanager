import 'package:flutter/material.dart';
import 'package:task_manager_app/app/modules/profile/store/profile_store.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileStore _store;

  ProfileProvider(this._store);

  String name = '';
  String email = '';
  String avatar = '';  // Novo campo para o avatar
  bool loading = false;

  Future<void> fetchProfile() async {
    loading = true;
    notifyListeners();

    try {
      final profile = await _store.fetchProfile();
      name = profile['name'];
      email = profile['email'];
      avatar = profile['avatar'] ?? '';  // Definindo a URL do avatar
    } catch (e) {
      print('Error fetching profile: $e');
    }

    loading = false;
    notifyListeners();
  }
  
}


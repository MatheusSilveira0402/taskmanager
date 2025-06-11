import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task_manager_app/app/modules/auth/stores/biometric_store.dart';

showBiometricModal(BuildContext context, BiometricAuthStore store,) async {
  final prefs = await SharedPreferences.getInstance();
  final firstTime = prefs.getBool('first_open') ?? true;

  if (firstTime) {
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Deseja habilitar login por digital?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await prefs.setBool('first_open', false);
            },
            child: const Text('Agora não'),
          ),
          TextButton(
            onPressed: () async {
              await store.toggleBiometric(true);

              await prefs.setBool('first_open', false);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Habilitar'),
          ),
        ],
      ),
    );
  }
}

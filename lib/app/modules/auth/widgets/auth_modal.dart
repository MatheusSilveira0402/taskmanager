import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task_manager_app/app/modules/auth/stores/biometric_store.dart';
import 'package:task_manager_app/app/widgets/custom_button.dart';

Future<void> showBiometricModal(BuildContext context, BiometricAuthStore store) async {
  final prefs = await SharedPreferences.getInstance();
  final firstTime = prefs.getBool('first_open') ?? true;

  if (firstTime) {
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.fingerprint,
                size: 64,
                color: Color(0xFF52B2AD),
              ),
              const SizedBox(height: 16),
              const Text(
                'Deseja habilitar login por digital?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF52B2AD),
                        side: const BorderSide(color: Color(0xFF52B2AD), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await prefs.setBool('first_open', false);
                      },
                      child: const Text(
                        'Agora não',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: "Habilitar",
                      onPressed: () async {
                        await store.toggleBiometric(true);
                        await prefs.setBool('first_open', false);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

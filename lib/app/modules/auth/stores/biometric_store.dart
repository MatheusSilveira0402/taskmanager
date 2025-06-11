import 'package:task_manager_app/app/core/log/debug_log.dart';
import 'package:task_manager_app/app/modules/auth/services/biometric_service.dart';
import 'package:task_manager_app/app/core/storege_security.dart';
import 'package:task_manager_app/app/modules/auth/stores/auth_store.dart';

class BiometricAuthStore {
  final BiometricService _service;
  final AuthStore authStore;

  BiometricAuthStore(this._service, this.authStore);

  Future<bool> loadBiometricStatus() async {
    final enabled = await _service.isBiometricEnabled();
    return enabled;
  }

  Future<void> toggleBiometric(bool enabled) async {
    await _service.setBiometricEnabled(enabled);
  }

  Future<bool> authenticateIfEnabled() async {
    

    bool biometricLogin = await _service.authenticate();
    final startTime = DateTime.now();
    logDebug('[BIOMETRIC] Início do processo: $startTime');
    final step1Start = DateTime.now();
    final step1End = DateTime.now();
    logDebug(
        '[BIOMETRIC] Autenticação biométrica: ${step1End.difference(step1Start).inMilliseconds} ms');

    final step2Start = DateTime.now();
    final email = await getSecureData('email');
    final password = await getSecureData('password');
    final step2End = DateTime.now();
    logDebug(
        '[BIOMETRIC] Leitura do storage seguro: ${step2End.difference(step2Start).inMilliseconds} ms');

    if (biometricLogin && email != null && password != null) {
      final step3Start = DateTime.now();
      await authStore.signIn(email, password);
      final step3End = DateTime.now();
      logDebug(
          '[BIOMETRIC] Login com Supabase: ${step3End.difference(step3Start).inMilliseconds} ms');

      final totalDuration = DateTime.now().difference(startTime).inMilliseconds;
      logDebug('[BIOMETRIC] Total do processo: $totalDuration ms');

      return true;
    }

    final totalDuration = DateTime.now().difference(startTime).inMilliseconds;
    logDebug('[BIOMETRIC] Processo encerrado sem login. Duração total: $totalDuration ms');

    return false;
  }
}

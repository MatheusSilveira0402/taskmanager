import 'package:supabase_flutter/supabase_flutter.dart';

/// Trata erros de autenticação vindos do Supabase e retorna mensagens amigáveis.
String getAuthErrorMessage(dynamic error) {
  if (error is AuthApiException) {
    final message = error.message.toLowerCase();

    if (message.contains('email not confirmed')) {
      return 'Seu e-mail ainda não foi confirmado. Verifique sua caixa de entrada.';
    }

    if (message.contains('invalid login credentials')) {
      return 'E-mail ou senha inválidos.';
    }

    if (message.contains('user not found')) {
      return 'Usuário não encontrado.';
    }

    if (message.contains('network')) {
      return 'Erro de conexão. Verifique sua internet.';
    }

    // Outros erros genéricos
    return error.message;
  }

  return 'Erro inesperado: $error';
}

/// Retorna uma mensagem amigável para erros do Supabase no fluxo de registro.
String getRegisterErrorMessage(dynamic error) {
  if (error is AuthApiException) {
    final message = error.message.toLowerCase();

    if (message.contains('email already registered') ||
        message.contains('duplicate key')) {
      return 'E-mail já cadastrado.';
    }

    if (message.contains('User already registered') ||
        message.contains('user_already_exists')) {
      return 'E-mail já cadastrado.';
    }

    if (message.contains('network')) {
      return 'Erro de conexão. Verifique sua internet.';
    }

    // Outras mensagens genéricas para registro
    return 'Erro ao registrar: ${error.message}';
  }

  return 'Erro inesperado. Por favor, tente novamente.';
}

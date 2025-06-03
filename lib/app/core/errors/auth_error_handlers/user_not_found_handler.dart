// lib/core/errors/auth_error_handlers/user_not_found_handler.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../error_handler.dart';

class UserNotFoundHandler implements ErrorHandler {
  @override
  bool canHandle(error) =>
      error is AuthApiException &&
      error.message.toLowerCase().contains('user not found');

  @override
  String getMessage(error) =>
      'Usuário não encontrado.';
}
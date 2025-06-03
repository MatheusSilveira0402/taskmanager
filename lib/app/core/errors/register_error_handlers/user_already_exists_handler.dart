// lib/core/errors/auth_error_handlers/email_not_confirmed_handler.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../error_handler.dart';

class UserAlreadyExistsHandler implements ErrorHandler {
  @override
  bool canHandle(error) =>
      error is AuthApiException &&
          error.message.toLowerCase().contains('User already registered') ||
      error.message.toLowerCase().contains('user_already_exists');

  @override
  String getMessage(error) =>
      'E-mail já cadastrado.';
}

// lib/core/errors/auth_error_handlers/invalid_credentials_handler.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../error_handler.dart';

class InvalidCredentialsHandler implements ErrorHandler {
  @override
  bool canHandle(error) =>
      error is AuthApiException &&
      error.message.toLowerCase().contains('invalid login credentials');

  @override
  String getMessage(error) =>
      'E-mail ou senha inválidos';
}
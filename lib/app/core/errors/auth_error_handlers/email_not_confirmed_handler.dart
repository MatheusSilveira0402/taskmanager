// lib/core/errors/auth_error_handlers/email_not_confirmed_handler.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../error_handler.dart';

class EmailNotConfirmedHandler implements ErrorHandler {
  @override
  bool canHandle(error) =>
      error is AuthApiException &&
      error.message.toLowerCase().contains('email not confirmed');

  @override
  String getMessage(error) =>
      'Seu e-mail ainda não foi confirmado. Verifique sua caixa de entrada.';
}
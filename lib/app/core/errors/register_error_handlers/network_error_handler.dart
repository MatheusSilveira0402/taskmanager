// lib/core/errors/register_error_handlers/network_error_handler.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../error_handler.dart';

class NetworkErrorHandler implements ErrorHandler {
  @override
  bool canHandle(error) =>
      error is AuthApiException &&
      error.message.toLowerCase().contains('network');

  @override
  String getMessage(error) =>
      'Erro de conexão. Verifique sua internet.';
}
// lib/core/errors/auth_error_handlers/generic_registrer_error_handler.dart
import '../error_handler.dart';

class GenericRegisterErrorHandler implements ErrorHandler {
  @override
  bool canHandle(error) =>
      error;

  @override
  String getMessage(error) =>
      'Erro inesperado. Por favor, tente novamente.';
}
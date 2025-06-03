// lib/core/errors/error_handler_strategy.dart
import 'package:task_manager_app/app/core/errors/auth_error_handlers/email_not_confirmed_handler.dart';
import 'package:task_manager_app/app/core/errors/auth_error_handlers/generic_auth_error_handler.dart';
import 'package:task_manager_app/app/core/errors/auth_error_handlers/invalid_credentials_handler.dart';
import 'package:task_manager_app/app/core/errors/auth_error_handlers/network_error_handler.dart';
import 'package:task_manager_app/app/core/errors/auth_error_handlers/user_not_found_handler.dart';
import 'package:task_manager_app/app/core/errors/register_error_handlers/email_already_registered_handler.dart';
import 'package:task_manager_app/app/core/errors/register_error_handlers/generic_register_error_handler.dart';
import 'package:task_manager_app/app/core/errors/register_error_handlers/user_already_exists_handler.dart';

import 'error_handler.dart';

class ErrorHandlerStrategy {
  final List<ErrorHandler> _authHandlers = [
    EmailNotConfirmedHandler(),
    InvalidCredentialsHandler(),
    UserNotFoundHandler(),
    NetworkErrorHandler(),
    GenericAuthErrorHandler(),
  ];

  final List<ErrorHandler> _registerHandlers = [
    EmailAlreadyRegisteredHandler(),
    UserAlreadyExistsHandler(),
    NetworkErrorHandler(),
    GenericRegisterErrorHandler(),
  ];

  String handleAuthError(dynamic error) {
    for (var handler in _authHandlers) {
      if (handler.canHandle(error)) {
        return handler.getMessage(error);
      }
    }
    return 'Erro inesperado: $error';
  }

  String handleRegisterError(dynamic error) {
    for (var handler in _registerHandlers) {
      if (handler.canHandle(error)) {
        return handler.getMessage(error);
      }
    }
    return 'Erro inesperado: $error';
  }
}

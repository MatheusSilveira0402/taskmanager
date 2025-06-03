// lib/core/errors/error_handler.dart
abstract class ErrorHandler {
  bool canHandle(dynamic error);
  String getMessage(dynamic error);
}
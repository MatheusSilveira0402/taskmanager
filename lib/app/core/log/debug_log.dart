import 'package:flutter/material.dart';

void logDebug(String message) {
  assert(() {
    debugPrint(message);
    return true;
  }());
}
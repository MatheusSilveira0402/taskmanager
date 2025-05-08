import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  
  double widthPct(double percent) => screenWidth * percent;

  double heightPct(double percent) => screenHeight * percent;
}

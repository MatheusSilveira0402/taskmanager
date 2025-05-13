import 'package:flutter/material.dart';

/// Extensão criada para facilitar o acesso a dimensões da tela
/// a partir do [BuildContext].
extension ContextExtensions on BuildContext {
  /// Retorna a largura total da tela.
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Retorna a altura total da tela.
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Retorna a largura da tela com base em uma porcentagem fornecida.
  ///
  /// [percent] deve estar entre 0.0 e 1.0, por exemplo:
  /// `context.widthPct(0.5)` retorna 50% da largura da tela.
  double widthPct(double percent) => screenWidth * percent;

  /// Retorna a altura da tela com base em uma porcentagem fornecida.
  ///
  /// [percent] deve estar entre 0.0 e 1.0, por exemplo:
  /// `context.heightPct(0.3)` retorna 30% da altura da tela.
  double heightPct(double percent) => screenHeight * percent;
}

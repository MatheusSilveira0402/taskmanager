import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Widget principal da aplicação.
///
/// Responsável por configurar o `MaterialApp.router`, incluindo tema,
/// título e integração com o sistema de rotas do Flutter Modular.
class AppWidget extends StatelessWidget {
  /// Construtor padrão do [AppWidget].
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      /// Título da aplicação, usado em algumas plataformas.
      title: 'Task Manager',

      /// Tema global da aplicação, definindo cor primária e fundo.
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFEEEEEE),
      ),

      /// Parser de rotas utilizado pelo Flutter Modular.
      routeInformationParser: Modular.routeInformationParser,

      /// Delegado de rotas utilizado pelo Flutter Modular.
      routerDelegate: Modular.routerDelegate,
    );
  }
}

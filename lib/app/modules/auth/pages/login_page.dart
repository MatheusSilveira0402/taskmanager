import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/widgets/custom_button.dart';
import 'package:task_manager_app/app/widgets/custom_text_field.dart';
import '../stores/auth_store.dart';

/// Página de login do aplicativo.
///
/// Permite que o usuário insira e-mail e senha para autenticação.
/// Utiliza `Supabase` para login e `Flutter Modular` para navegação.
class LoginPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authStore = Modular.get<AuthStore>();

  LoginPage({super.key});

  /// Função responsável por realizar o login do usuário.
  ///
  /// Caso o login seja bem-sucedido, redireciona para a página principal (`/main`).
  /// Em caso de erro, exibe uma mensagem apropriada.
  void _login(BuildContext context) async {
    try {
      await _authStore.signIn(_emailController.text, _passwordController.text);
      Modular.to.navigate('/main');
    } catch (e) {
      if (!context.mounted) return;

      String errorMessage = 'Erro ao fazer login. Tente novamente mais tarde.';

      if (e is AuthApiException) {
        if (e.message.contains('Email not confirmed')) {
          errorMessage =
              'Seu e-mail ainda não foi confirmado. Verifique sua caixa de entrada.';
        } else {
          errorMessage = e.message;
        }
      } else {
        errorMessage = 'Erro inesperado: $e';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF52B2AD),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Cabeçalho com a logo
            Container(
              width: context.screenWidth,
              height: context.heightPct(0.6),
              decoration: const BoxDecoration(color: Color(0xFF52B2AD)),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            /// Card com o formulário de login
            Card(
              elevation: 4,
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(15),
                width: context.widthPct(1),
                height: context.heightPct(0.5),
                child: Column(
                  spacing: 18.0,
                  children: [
                    /// Campo de e-mail
                    CustomTextField(
                      controller: _emailController,
                      label: 'E-mail',
                      icon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um email';
                        }
                        return null;
                      },
                    ),

                    /// Campo de senha
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Senha',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira uma senha';
                        }
                        return null;
                      },
                    ),

                    /// Botão de login
                    CustomButton(
                      text: 'Entrar',
                      onPressed: () => _login(context),
                    ),

                    /// Link para a página de registro
                    TextButton(
                      onPressed: () => Modular.to.pushNamed('/register'),
                      child: const Text(
                        'Criar conta',
                        style: TextStyle(color: Color(0xFF52B2AD)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

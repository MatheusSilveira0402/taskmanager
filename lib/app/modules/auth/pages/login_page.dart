import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/widgets/custom_button.dart';
import 'package:task_manager_app/app/widgets/custom_text_field.dart';
import '../stores/auth_store.dart';

class LoginPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authStore = Modular.get<AuthStore>();

  LoginPage({super.key});

  void _login(BuildContext context) async {
    try {
      await _authStore.signIn(_emailController.text, _passwordController.text);
      Modular.to.navigate('/main');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF52B2AD),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: context.screenWidth,
              height: context.heightPct(0.6),
              decoration: const BoxDecoration(color: Color(0xFF52B2AD)),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png', // Altere o caminho conforme sua estrutura
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                padding: const EdgeInsets.all(15),
                width: context.widthPct(1),
                height: context.heightPct(0.5),
                child: Column(
                  spacing: 18.0,
                  children: [
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
                    CustomButton(
                      text: 'Entrar',
                      onPressed: () => _login(context),
                    ),
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

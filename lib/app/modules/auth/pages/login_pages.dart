import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../stores/auth_store.dart';

class LoginPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authStore = Modular.get<AuthStore>();

  LoginPage({super.key});

  void _login(BuildContext context) async {
    try {
      await _authStore.signIn(_emailController.text, _passwordController.text);
      Modular.to.navigate('/home/');
    } catch (e) {
      if(!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao fazer login: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _login(context),
              child: const Text('Entrar'),
            ),
            TextButton(
              onPressed: () => Modular.to.pushNamed('/register'),
              child: const Text('Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}

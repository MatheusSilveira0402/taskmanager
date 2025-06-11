import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/core/errors/error_handler_strategy.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/modules/auth/providers/auth_avatar_provider.dart';
import 'package:task_manager_app/app/modules/auth/widgets/auth_avatar.dart';

import 'package:task_manager_app/app/widgets/custom_button.dart';
import 'package:task_manager_app/app/widgets/custom_text_field.dart';
import '../stores/auth_store.dart';

/// Página de cadastro de novos usuários.
///
/// Esta página permite que o usuário insira seu nome, e-mail, senha
/// e opcionalmente uma imagem de perfil para criar uma conta.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controladores dos campos de entrada
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  // Store de autenticação responsável por lidar com a lógica de cadastro
  final _authStore = Modular.get<AuthStore>();

  // Imagem de perfil selecionada pelo usuário (opcional)
  String? _image;

  /// Realiza o processo de cadastro do usuário.
  ///
  /// Envia os dados preenchidos (nome, e-mail, senha) e a imagem (caso exista)
  /// para o método de cadastro do [AuthStore].
  /// Mostra feedback visual com `SnackBar` sobre sucesso ou erro.
  void _register(BuildContext context) async {
    final errorStrategy = ErrorHandlerStrategy();
    _image = Modular.get<AuthAvatarProvider>().pickedImage;
    try {
      await _authStore.signUp(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _image,
      );
      // sucesso...
      if (!context.mounted) return;

      // Mostra mensagem de sucesso e retorna à tela anterior
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
      Modular.to.navigate('/main');
    } catch (e) {
      final errorMessage = errorStrategy.handleRegisterError(e);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.screenWidth,
        height: context.screenHeight,
        child: Stack(
          children: [
            // Fundo decorativo com bordas arredondadas
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: context.heightPct(0.3),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(127, 82, 178, 173),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
              ),
            ),

            // Conteúdo rolável principal da tela
            SingleChildScrollView(
              child: Column(
                spacing: 20.0,
                children: [
                  // AppBar personalizada
                  SizedBox(
                    height: context.heightPct(0.2) + 25,
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      toolbarHeight: 90,
                      titleTextStyle: const TextStyle(
                        fontSize: 40,
                        color: Color(0xFF0f2429),
                      ),
                      title: const Text('Cadastro'),
                    ),
                  ),

                  // Avatar interativo (por enquanto não conectado ao _image)
                  const AuthAvatar(),

                  // Formulário de cadastro
                  Container(
                    margin: const EdgeInsets.all(10),
                    height: context.heightPct(0.8),
                    child: Column(
                      spacing: 20.0,
                      children: [
                        CustomTextField(
                          controller: _nameController,
                          label: 'Nome',
                          icon: Icons.person_outline,
                        ),
                        CustomTextField(
                          controller: _emailController,
                          label: 'E-mail',
                          keyboardType: TextInputType.emailAddress,
                          icon: Icons.email_outlined,
                        ),
                        CustomTextField(
                          controller: _passwordController,
                          label: 'Senha',
                          icon: Icons.lock_outline,
                          obscureText: true,
                        ),
                        CustomButton(
                          text: 'Cadastrar',
                          onPressed: () async {
                            _register(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

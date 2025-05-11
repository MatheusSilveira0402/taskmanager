import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/widgets/custom_button.dart';
import 'package:task_manager_app/app/widgets/custom_text_field.dart';
import '../stores/auth_store.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _authStore = Modular.get<AuthStore>();

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _register(BuildContext context) async {
    try {
      // Aqui você pode usar a _image como desejar (ex: enviar para API)
      await _authStore.signUp(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _image, // envia a imagem (se existir)
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
      Modular.to.pop();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: $e')),
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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: context.heightPct(0.3),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(127, 82, 178, 173),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                spacing: 20.0,
                children: [
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
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(Icons.person, size: 50, color: Colors.white70)
                          : null,
                    ),
                  ),
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
                          onPressed: () => _register(context),
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

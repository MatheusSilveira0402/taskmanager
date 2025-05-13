import 'package:flutter/material.dart';

/// Um campo de texto customizado com ícone, estilo consistente e suporte a validação.
///
/// O `CustomTextField` é um `TextFormField` encapsulado que oferece opções para
/// configuração do ícone, rótulo, tipo de teclado, modo senha e validador,
/// mantendo um estilo visual unificado em toda a aplicação.
class CustomTextField extends StatelessWidget {
  /// Controlador do texto que permite ler e modificar o conteúdo do campo.
  final TextEditingController controller;

  /// Texto exibido como rótulo acima do campo.
  final String label;

  /// Ícone exibido à esquerda do campo de texto (opcional).
  final IconData? icon;

  /// Define se o texto será obscurecido (útil para senhas).
  final bool obscureText;

  /// Define o tipo de teclado (ex: texto, número, e-mail, etc.).
  final TextInputType keyboardType;

  /// Função de validação que retorna uma mensagem de erro ou null.
  final FormFieldValidator<String>? validator;

  /// Construtor do campo de texto customizado.
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        filled: true,
        labelStyle: const TextStyle(color: Colors.black),
        prefixIconColor: const Color(0xFF52B2AD),
        fillColor: Colors.grey[300],
        focusColor: const Color(0xFF52B2AD),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}

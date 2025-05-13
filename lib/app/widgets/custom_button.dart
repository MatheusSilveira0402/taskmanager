import 'package:flutter/material.dart';

/// Um botão customizado (ElevatedButton) para o aplicativo.
///
/// O `CustomButton` é um widget reutilizável que facilita a criação de botões com um estilo
/// consistente em todo o aplicativo. Ele recebe um texto para exibição e uma função de callback
/// para ser executada quando o botão for pressionado.
class CustomButton extends StatelessWidget {
  // Texto que será exibido no botão
  final String text;

  // Função que será chamada quando o botão for pressionado
  final VoidCallback onPressed;

  // Construtor que exige o texto do botão e a função onPressed
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // O botão ocupa toda a largura disponível
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // Define o padding vertical para o botão
          padding: const EdgeInsets.symmetric(vertical: 14),
          // Define o estilo do botão, com bordas arredondadas
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // Define a cor de fundo do botão
          backgroundColor: const Color(0xFF52B2AD),
        ),
        onPressed: onPressed, // Ação a ser executada quando pressionado
        child: Text(
          text, // O texto a ser exibido no botão
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

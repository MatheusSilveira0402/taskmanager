import 'package:flutter/material.dart';

/// Um campo de seleção personalizado com dropdown.
///
/// O `CustomDropdown` é um widget que permite ao usuário escolher um valor a partir de uma lista de opções
/// em um dropdown. Ele é um `DropdownButtonFormField` que oferece uma interface limpa e customizável, permitindo
/// a seleção de diferentes tipos de itens com a possibilidade de adicionar um label e um estilo consistente.
/// Exemplo de uso:
/// CustomDropdown<String>(
///   label: 'Selecione uma opção',
///   value: selectedOption,
///   items: [
///     DropdownMenuItem<String>(
///       value: 'Opção 1',
///       child: Text('Opção 1'),
///     ),
///     DropdownMenuItem<String>(
///       value: 'Opção 2',
///       child: Text('Opção 2'),
///     ),
///   ],
///   onChanged: (value) {
///     setState(() {
///       selectedOption = value!;
///     });
///   },
/// )
class CustomDropdown<T> extends StatelessWidget {
  // O texto do label do campo de seleção
  final String label;

  // O valor atualmente selecionado no dropdown
  final T value;

  // Lista de itens do dropdown que o usuário pode escolher
  final List<DropdownMenuItem<T>> items;

  // Função de callback chamada quando o valor é alterado
  final ValueChanged<T?> onChanged;

  // Construtor para inicializar o CustomDropdown com o label, valor atual, lista de itens e callback
  const CustomDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        // Estilo do campo, com preenchimento de fundo e bordas arredondadas
        fillColor: Colors.grey[300],
        labelText: label,
        border: InputBorder.none,
        filled: true,
        labelStyle: const TextStyle(color: Colors.black),
        prefixIconColor: const Color(0xFF52B2AD),
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
      items: items, // Itens do dropdown
      onChanged: onChanged, // Função de callback chamada quando o valor muda
      dropdownColor: Colors.grey[300], // Cor do fundo do menu suspenso
      iconEnabledColor: const Color(0xFF52B2AD), // Cor do ícone de dropdown
      style: const TextStyle(color: Colors.black), // Estilo do texto no campo
      elevation: 3, // Elevação para a sombra do menu suspenso
      isExpanded: true, // Garante que o dropdown ocupe toda a largura disponível
    );
  }
}

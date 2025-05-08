import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

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
      items: items,
      onChanged: onChanged,
      dropdownColor: Colors.grey[300], 
      iconEnabledColor: const Color(0xFF52B2AD), 
      style: const TextStyle(color: Colors.black),
      elevation: 3, // Sombra do menu suspenso
      isExpanded: true, // Garante que o dropdown se expanda para todo o tamanho possível
    );
  }
}

import 'package:flutter/material.dart';

class CustomDatePickerButton extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String label;
  final double? width;
  final double? height;

  const CustomDatePickerButton({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.label = 'Selecionar Data',
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 35,
      child: OutlinedButton(
        onPressed: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.teal, // Cor do círculo selecionado
                        onPrimary: Colors.white, // Texto dentro do círculo selecionado
                        onSurface: Colors.black87, // Texto padrão
                      ), dialogTheme: const DialogThemeData(backgroundColor: Colors.white), // Fundo do calendário
                    ),
                    child: child!,
                  );
                },
          );
          if (picked != null) {
            onDateSelected(picked);
          }
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          side: const BorderSide(color: Color(0xFF00695c), width: 1),
          foregroundColor: const Color(0xFF00695c),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 3.0,
          children: [
            Text(
              selectedDate != null
                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : label,
              style: const TextStyle(fontSize: 14),
            ),
            const Icon(Icons.calendar_today, size: 14, color: Color(0xFF00695c),),
          ],
        ),
      ),
    );
  }
}

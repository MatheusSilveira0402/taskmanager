// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class CustomDatePickerInput extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String label;
  final double? width;
  final double? height;
  final String? Function(DateTime?)? validator;

  const CustomDatePickerInput({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.label = 'Selecionar data/hora',
    this.width,
    this.height,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: selectedDate,
      validator: validator,
      builder: (field) {
        final hasError = field.hasError;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  errorFormatText: "Formato inválido. Exemplo: dd/mm/aaaa",
                );

                if (pickedDate != null) {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(selectedDate ?? DateTime.now()),
                  );

                  final finalDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime?.hour ?? 0,
                    pickedTime?.minute ?? 0,
                  );

                  onDateSelected(finalDateTime);
                  field.didChange(finalDateTime); // <- informa mudança ao FormField
                }
              },
              child: Container(
                width: width,
                height: height ?? 55,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  border: hasError
                      ? Border.all(color: Colors.red)
                      : Border.all(color: Colors.transparent),
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    const Icon(Icons.calendar_today, size: 18, color: Color(0xFF52B2AD)),
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year} ${selectedDate!.hour.toString().padLeft(2, '0')}:${selectedDate!.minute.toString().padLeft(2, '0')}'
                          : label,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 8),
                child: Text(
                  field.errorText ?? '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}


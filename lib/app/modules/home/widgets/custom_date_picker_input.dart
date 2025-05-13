import 'package:flutter/material.dart';

/// Widget personalizado para seleção de data e hora.
///
/// Este widget oferece uma interface para o usuário escolher uma data e hora.
/// Ele exibe um campo de texto que exibe a data/hora selecionada e permite
/// ao usuário escolher uma nova data/hora através de um `DatePicker` e `TimePicker`.
/// 
/// A data e hora selecionadas são passadas de volta por meio de um callback [onDateSelected].
class CustomDatePickerInput extends StatelessWidget {
  /// Data selecionada atualmente.
  final DateTime? selectedDate;

  /// Função chamada quando uma nova data/hora é selecionada.
  final ValueChanged<DateTime> onDateSelected;

  /// Rótulo exibido quando não há data selecionada.
  final String label;

  /// Largura do campo de input.
  final double? width;

  /// Altura do campo de input.
  final double? height;

  /// Validador opcional para o campo de data.
  final String? Function(DateTime?)? validator;

  /// Construtor do widget [CustomDatePickerInput].
  ///
  /// - [selectedDate]: data e hora atualmente selecionadas.
  /// - [onDateSelected]: função de callback que recebe a nova data selecionada.
  /// - [label]: texto a ser exibido quando não há data selecionada.
  /// - [width] e [height]: tamanho do campo de input.
  /// - [validator]: função de validação para o campo de data.
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
                // Exibe o DatePicker para seleção de data
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  errorFormatText: "Formato inválido. Exemplo: dd/mm/aaaa",
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Colors.teal, // Cor do círculo selecionado
                          onPrimary: Colors.white, // Texto dentro do círculo selecionado
                          onSurface: Colors.black87, // Texto padrão
                        ),
                        dialogTheme: const DialogThemeData(
                            backgroundColor: Colors.white), // Fundo do calendário
                      ),
                      child: child!,
                    );
                  },
                );

                // Se a data for selecionada, exibe o TimePicker
                if (pickedDate != null) {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(selectedDate ?? DateTime.now()),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          timePickerTheme: const TimePickerThemeData(
                            hourMinuteColor: Colors.teal,
                            hourMinuteTextColor: Colors.white,
                            dialHandColor: Colors.teal,
                            dialBackgroundColor: Colors.white,
                            dialTextColor: Colors.black,
                            entryModeIconColor: Colors.teal,
                          ),
                          colorScheme: const ColorScheme.light(
                            primary: Colors.teal,
                            onPrimary: Colors.white,
                            onSurface: Colors.black87,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.teal,
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  // Combina a data e hora selecionadas em um único objeto DateTime
                  final finalDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime?.hour ?? 0,
                    pickedTime?.minute ?? 0,
                  );

                  // Notifica o novo valor para o widget pai e atualiza o campo
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

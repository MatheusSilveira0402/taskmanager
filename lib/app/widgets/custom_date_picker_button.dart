import 'package:flutter/material.dart';
import 'package:task_manager_app/app/core/extension_size.dart';

/// Um botão personalizado para selecionar uma data.
///
/// O `CustomDatePickerButton` é um widget que apresenta um botão com um texto (label) 
/// e permite ao usuário selecionar uma data a partir de um calendário pop-up. O botão exibe 
/// a data selecionada ou, se nenhuma data for selecionada, o texto padrão "Selecionar Data".
/// Quando o usuário escolhe uma data, o valor é retornado por meio de um callback.
class CustomDatePickerButton extends StatelessWidget {
  // Data selecionada, se houver
  final DateTime? selectedDate;

  // Função de callback chamada quando uma data é selecionada
  final ValueChanged<DateTime> onDateSelected;

  // Texto exibido no botão quando nenhuma data foi selecionada
  final String label;

  // Largura personalizada para o botão
  final double? width;

  // Altura personalizada para o botão
  final double? height;

  // Construtor que inicializa as variáveis do botão
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
      // Define a largura e altura do botão, sendo altura fixa de 50
      width: width,
      height: height ?? 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Botão de contorno (OutlinedButton) que abre o calendário
          OutlinedButton(
            onPressed: () async {
              // Exibe o calendário para o usuário escolher a data
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  // Personaliza o tema do calendário
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.teal, // Cor do círculo selecionado
                        onPrimary: Colors.white, // Texto dentro do círculo selecionado
                        onSurface: Colors.black87, // Texto padrão
                      ),
                      dialogTheme: const DialogThemeData(backgroundColor: Colors.white), // Fundo do calendário
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                // Se uma data for escolhida, chama a função onDateSelected
                onDateSelected(picked);
              }
            },
            style: OutlinedButton.styleFrom(
              // Estilo do botão: bordas arredondadas, cor do contorno e do texto
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              side: const BorderSide(color: Color(0xFF00695c), width: 1),
              foregroundColor: const Color(0xFF00695c),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 3.0,
              children: [
                // Exibe a data formatada ou o label se nenhuma data for escolhida
                Text(
                  selectedDate != null
                      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                      : label,
                  style: TextStyle(fontSize: selectedDate != null ? context.widthPct(0.030) : context.widthPct(0.025)),
                ),
                const Icon(Icons.calendar_today), // Ícone do calendário
              ],
            ),
          ),
        ],
      ),
    );
  }
}

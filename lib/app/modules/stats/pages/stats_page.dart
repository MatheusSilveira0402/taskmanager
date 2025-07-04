import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/modules/stats/pages/profile_page.dart';
import 'package:task_manager_app/app/modules/stats/provider/stats_provider.dart';
import 'package:task_manager_app/app/modules/stats/widgets/custom_date_picker_button.dart';
import 'package:task_manager_app/app/modules/stats/widgets/stats_card.dart';
import 'package:task_manager_app/app/modules/stats/widgets/stats_skeleton.dart';

/// A `StatsPage` é responsável por exibir as estatísticas do usuário,
/// incluindo gráficos de desempenho, resumo de tarefas, e filtros de data.
///
/// Ela utiliza o `StatsProvider` para buscar e exibir dados relacionados
/// às tarefas criadas, concluídas e pendentes dentro de um intervalo de
/// datas selecionado.
class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  /// Instância do provedor de estatísticas, responsável por buscar e gerenciar
  /// as informações de desempenho e tarefas do usuário.
  StatsProvider statsProvider = Modular.get<StatsProvider>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      statsProvider.fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Assiste ao estado do provedor de estatísticas para atualizar a UI
    final provider = context.watch<StatsProvider>();

    // Exibe um skeleton de carregamento enquanto os dados estão sendo buscados.
    if (provider.loading) {
      return const StatsSkeleton();
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(127, 82, 178, 173),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
              height: context.heightPct(0.4),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.only(bottom: 20, top: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20.0,
                children: [
                  // Conteúdo da página, incluindo cards de resumo e gráficos
                  Column(
                    spacing: 10.0,
                    children: [
                      // Exibe a página de perfil do usuário
                      SizedBox(
                        width: context.widthPct(1),
                        child: const ProfilePage(),
                      ),
                      // Seção de filtros para selecionar o intervalo de datas
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 10.0,
                            children: [
                              // Seção para selecionar a data inicial
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      "DATA INÍCIO",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF00695c),
                                          fontSize: context.heightPct(0.015)),
                                    ),
                                  ),
                                  CustomDatePickerButton(
                                      width: context.widthPct(0.2),
                                      height: context.widthPct(0.1),
                                      selectedDate: provider.startDate,
                                      onDateSelected: (startDate) {
                                        provider.setSelectedDate(
                                            startDate, provider.endDate);
                                      }),
                                ],
                              ),
                              // Seção para selecionar a data final
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Text("DATA FIM",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF00695c),
                                            fontSize: context.heightPct(0.015))),
                                  ),
                                  CustomDatePickerButton(
                                      width: context.widthPct(0.2),
                                      height: context.widthPct(0.1),
                                      selectedDate: provider.endDate,
                                      onDateSelected: (endDate) {
                                        provider.setSelectedDate(
                                            provider.startDate, endDate);
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Cards de Resumo com informações sobre as tarefas
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StatCard(title: 'Criadas', value: provider.total.toString()),
                            StatCard(
                                title: 'Concluídas',
                                value: provider.completed.toString()),
                            StatCard(
                                title: 'Progresso', value: provider.progress.toString()),
                            StatCard(
                                title: 'Pendentes', value: provider.pending.toString()),
                          ],
                        ),
                      ),
                      // Gráfico de tarefas concluídas por dia
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tarefas concluídas na semana',
                                style: TextStyle(
                                  fontSize: context.heightPct(0.020),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: context.heightPct(0.2),
                                child: BarChart(
                                  BarChartData(
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: (provider.completedPerDay
                                                .reduce((a, b) => a > b ? a : b) +
                                            1)
                                        .toDouble(),
                                    gridData: FlGridData(
                                      show: true,
                                      drawHorizontalLine: true,
                                      getDrawingHorizontalLine: (value) => FlLine(
                                        color: Colors.grey[300],
                                        strokeWidth: 1,
                                      ),
                                      drawVerticalLine: false,
                                    ),
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 30,
                                          getTitlesWidget: (value, _) {
                                            const days = [
                                              'D',
                                              'S',
                                              'T',
                                              'Q',
                                              'Q',
                                              'S',
                                              'S'
                                            ];
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Text(
                                                days[value.toInt()],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      leftTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false)),
                                      topTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false)),
                                      rightTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false)),
                                    ),
                                    borderData: FlBorderData(show: false),
                                    barGroups: List.generate(7, (i) {
                                      return BarChartGroupData(
                                        x: i,
                                        barRods: [
                                          BarChartRodData(
                                            toY: provider.completedPerDay[i].toDouble(),
                                            width: 30,
                                            color: const Color(
                                                0xFF52B2AD), // Cor sólida como na imagem
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Progresso geral das tarefas
                      Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              Text(
                                'Progresso geral',
                                style:
                                    TextStyle(fontSize: context.heightPct(0.020), fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${provider.total == 0 ? 0 : (provider.completed / provider.total * 100).toStringAsFixed(0)}% concluído',
                                style: TextStyle(
                                    fontSize: context.heightPct(0.020),
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF52B2AD)),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: provider.total == 0
                                      ? 0
                                      : provider.completed / provider.total,
                                  minHeight: 12,
                                  backgroundColor: Colors.grey[300],
                                  color: const Color(0xFF52B2AD),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

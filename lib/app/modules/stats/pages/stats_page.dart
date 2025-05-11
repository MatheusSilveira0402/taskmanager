import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/modules/stats/pages/profile_page.dart';
import 'package:task_manager_app/app/modules/stats/provider/stats_provider.dart';
import 'package:task_manager_app/app/modules/stats/widgets/custom_date_picker_button.dart';
import 'package:task_manager_app/app/modules/stats/widgets/stats_card.dart';
import 'package:task_manager_app/app/modules/stats/widgets/stats_skeleton.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late StatsProvider statsProvider;

  @override
  void initState() {
    super.initState();
    statsProvider = context.read<StatsProvider>();

    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 6));

    statsProvider.setSelectedDate(startDate, now);
    statsProvider.fetchStats();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StatsProvider>();

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
              height: context.heightPct(0.4) - 60,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.0,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 90,
                titleTextStyle: const TextStyle(fontSize: 40, color: Color(0xFF0f2429)),
                title: Container(
                  margin: const EdgeInsets.only(right: 2),
                  child: const Text("Estatísticas"),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10.0,
                    children: [
                      SizedBox(
                        width: context.widthPct(1),
                        child: const ProfilePage(),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 10.0,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Text("DATA INÍCIO",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF00695c))),
                                  ),
                                  CustomDatePickerButton(
                                      width: 130,
                                      selectedDate: provider.startDate,
                                      onDateSelected: (startDate) {
                                        provider.setSelectedDate(
                                            startDate, provider.endDate);
                                      }),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Text("DATA FIM",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF00695c))),
                                  ),
                                  CustomDatePickerButton(
                                      width: 130,
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
                      // Cards de Resumo
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tarefas concluídas na semana',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
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
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Progresso geral',
                                style:
                                    TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${provider.total == 0 ? 0 : (provider.completed / provider.total * 100).toStringAsFixed(0)}% concluído',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF52B2AD)),
                              ),
                              const SizedBox(height: 8),
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
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

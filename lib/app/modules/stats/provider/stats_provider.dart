import 'package:flutter/material.dart';
import 'package:task_manager_app/app/modules/stats/store/stats_store.dart';


class StatsProvider extends ChangeNotifier {
  final StatsStore _store;

  StatsProvider(this._store);

  List<int> completedPerDay = [0, 0, 0, 0, 0, 0, 0];
  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  bool loading = false;

  int total = 0;
  int pending = 0;
  int progress = 0;
  int completed = 0;
  int overdue = 0;
  int today = 0;

  // Modifique a função para passar as datas como parâmetros
  Future<void> fetchStats() async {
    loading = true;
    notifyListeners();

    try {
      final stats = await _store.fetchStats(_startDate, _endDate);
      total = stats['total'];
      pending = stats['pending'];
      progress = stats['progress'];
      completed = stats['completed'];
      overdue = stats['overdue'];
      today = stats['today'];
      completedPerDay = List<int>.from(stats['completedPerDay']);
    } catch (e) {
      print('Erro ao buscar stats: $e');
    }

    loading = false;
    notifyListeners();
  }

  void setSelectedDate(DateTime? startDate, DateTime? endDate) {
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();
    fetchStats();  // Refazer a busca com as novas datas
  }
}



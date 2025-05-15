import 'package:flutter/material.dart';
import 'package:task_manager_app/app/modules/stats/store/stats_store.dart';

/// O `StatsProvider` gerencia o estado das estatísticas relacionadas às tarefas,
/// incluindo dados como o total de tarefas, pendentes, concluídas e progressos.
/// Ele também lida com a busca de dados de tarefas em um intervalo de datas específico.
///
/// Ele usa o `StatsStore` para comunicar-se com o armazenamento ou API para buscar os dados.
class StatsProvider extends ChangeNotifier {
  final StatsStore _store;

  // Construtor que recebe uma instância do StatsStore
  StatsProvider(this._store);

  // Lista que armazena a quantidade de tarefas concluídas por dia na semana
  List<int> completedPerDay = [0, 0, 0, 0, 0, 0, 0];

  // Variáveis que armazenam as datas de início e fim selecionadas
  DateTime? _startDate;
  DateTime? _endDate;

  // Getters para acessar as datas de início e fim
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // Indicador de carregamento para mostrar na UI durante requisições
  bool loading = false;

  // Variáveis para armazenar os dados das estatísticas
  int total = 0; // Total de tarefas
  int pending = 0; // Tarefas pendentes
  int progress = 0; // Tarefas em progresso
  int completed = 0; // Tarefas concluídas
  int overdue = 0; // Tarefas vencidas
  int today = 0; // Tarefas para hoje

  /// Método assíncrono que busca as estatísticas das tarefas no intervalo de datas
  /// entre `startDate` e `endDate` através do `StatsStore`.
  ///
  /// Atualiza os dados e notifica os ouvintes da mudança.
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
      debugPrint('Erro ao buscar stats: $e'); // Exibe erro no console caso a requisição falhe
    }

    loading = false;
    notifyListeners();
  }

  /// Método para definir as datas de início e fim do intervalo e refazer a busca das estatísticas.
  ///
  /// Chamado sempre que o usuário seleciona novas datas.
  void setSelectedDate(DateTime? startDate, DateTime? endDate) {
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();
    fetchStats();  // Refaz a busca das estatísticas com as novas datas
  }
}

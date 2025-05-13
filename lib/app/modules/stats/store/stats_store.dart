import 'package:supabase_flutter/supabase_flutter.dart';

/// O `StatsStore` é responsável por interagir com a base de dados do Supabase
/// para buscar e calcular as estatísticas das tarefas do usuário, como o total de tarefas,
/// status das tarefas (pendente, em progresso, concluída), tarefas vencidas, tarefas do dia,
/// e tarefas concluídas por dia.
class StatsStore {
  final supabase = Supabase.instance.client;

  /// Método assíncrono que busca as estatísticas das tarefas do usuário no Supabase.
  /// Aceita parâmetros `startDate` e `endDate` para filtrar as tarefas por data.
  ///
  /// Retorna um `Map<String, dynamic>` com as estatísticas calculadas:
  /// - total: Total de tarefas no período.
  /// - pending: Tarefas pendentes.
  /// - progress: Tarefas em progresso.
  /// - completed: Tarefas concluídas.
  /// - overdue: Tarefas vencidas.
  /// - today: Tarefas do dia.
  /// - completedPerDay: Lista de tarefas concluídas por dia da semana.
  Future<Map<String, dynamic>> fetchStats(DateTime? startDate, DateTime? endDate) async {
    final userId = supabase.auth.currentUser!.id;

    // Filtra as tarefas pelo ID do usuário
    var query = supabase.from('tasks').select('status, scheduled_at, completed_at').eq('user_id', userId);

    // Aplica os filtros de data, caso sejam passados
    if (startDate != null) {
      query = query.gte('scheduled_at', startDate.toIso8601String());
    }

    if (endDate != null) {
      query = query.lte('scheduled_at', endDate.toIso8601String());
    }

    // Executa a consulta
    final response = await query;

    // Converte a resposta para uma lista de dados
    final List data = response as List;

    // Retorna as estatísticas calculadas
    return {
      'total': data.length,
      'pending': data.where((item) => item['status'] == 'pending').length,
      'progress': data.where((item) => item['status'] == 'progress').length,
      'completed': data.where((item) => item['status'] == 'completed').length,
      'overdue': data.where((item) => _isOverdue(item['scheduled_at'])).length,
      'today': data.where((item) => _isToday(item['scheduled_at'])).length,
      'completedPerDay': calculateCompletedPerDay(data), // Chama a função para calcular tarefas concluídas por dia
    };
  }

  /// Verifica se uma tarefa está vencida (se a data de agendamento é anterior ao momento atual).
  bool _isOverdue(String? scheduledAt) {
    final now = DateTime.now();
    final scheduledDate = DateTime.tryParse(scheduledAt ?? '');
    return scheduledDate != null && scheduledDate.isBefore(now);
  }

  /// Verifica se uma tarefa foi agendada para o dia de hoje.
  bool _isToday(String? scheduledAt) {
    final now = DateTime.now();
    final scheduledDate = DateTime.tryParse(scheduledAt ?? '');
    return scheduledDate != null &&
        scheduledDate.year == now.year &&
        scheduledDate.month == now.month &&
        scheduledDate.day == now.day;
  }

  /// Calcula o número de tarefas concluídas por dia da semana.
  ///
  /// Retorna uma lista de inteiros representando a quantidade de tarefas concluídas em cada dia da semana.
  List<int> calculateCompletedPerDay(List data) {
    List<int> completedPerDay = [0, 0, 0, 0, 0, 0, 0]; // Inicia com zeros para cada dia da semana
    final now = DateTime.now();

    // Itera sobre as tarefas e conta as concluídas por dia
    for (final item in data) {
      final status = item['status'];
      final completedAt =
          item['completed_at'] != null ? DateTime.tryParse(item['completed_at']) : null;

      // Conta apenas tarefas concluídas
      if (status == 'completed' && completedAt != null) {
        final daysDifference = now.difference(completedAt).inDays;

        // Verifica se a tarefa foi concluída dentro da última semana e ajusta o índice do dia da semana
        if (daysDifference >= 0 && daysDifference < 7 && completedAt.weekday != 7) {
          final dayIndex = completedAt.weekday;
          completedPerDay[dayIndex]++;
        } else {
          const dayIndex = 0; // Caso a tarefa não tenha sido concluída esta semana, conta para o primeiro dia
          completedPerDay[dayIndex]++;
        }
      }
    }

    return completedPerDay;
  }
}

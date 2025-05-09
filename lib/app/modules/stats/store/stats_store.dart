import 'package:supabase_flutter/supabase_flutter.dart';

class StatsStore {
  final supabase = Supabase.instance.client;

  // Modifique a função para aceitar startDate e endDate
  Future<Map<String, dynamic>> fetchStats(DateTime? startDate, DateTime? endDate) async {
    final userId = supabase.auth.currentUser!.id;

    // Modifique a consulta para filtrar as tarefas pela data
    var query = supabase.from('tasks').select('status, scheduled_at, completed_at').eq('user_id', userId);

    if (startDate != null) {
      query = query.gte('scheduled_at', startDate.toIso8601String());  // Filtra pela data de início
    }

    if (endDate != null) {
      query = query.lte('scheduled_at', endDate.toIso8601String());  // Filtra pela data final
    }

    final response = await query;

    final List data = response as List;

    return {
      'total': data.length,
      'pending': data.where((item) => item['status'] == 'pending').length,
      'progress': data.where((item) => item['status'] == 'progress').length,
      'completed': data.where((item) => item['status'] == 'completed').length,
      'overdue': data.where((item) => _isOverdue(item['scheduled_at'])).length,
      'today': data.where((item) => _isToday(item['scheduled_at'])).length,
      'completedPerDay': calculateCompletedPerDay(data), // Chama a função de cálculo
    };
  }

  bool _isOverdue(String? scheduledAt) {
    final now = DateTime.now();
    final scheduledDate = DateTime.tryParse(scheduledAt ?? '');
    return scheduledDate != null && scheduledDate.isBefore(now);
  }

  bool _isToday(String? scheduledAt) {
    final now = DateTime.now();
    final scheduledDate = DateTime.tryParse(scheduledAt ?? '');
    return scheduledDate != null &&
        scheduledDate.year == now.year &&
        scheduledDate.month == now.month &&
        scheduledDate.day == now.day;
  }

  List<int> calculateCompletedPerDay(List data) {
    List<int> completedPerDay = [0, 0, 0, 0, 0, 0, 0]; // Inicia a lista com zeros
    final now = DateTime.now();

    for (final item in data) {
      final status = item['status'];
      final completedAt =
          item['completed_at'] != null ? DateTime.tryParse(item['completed_at']) : null;

      if (status == 'completed' && completedAt != null) {
        final daysDifference = now.difference(completedAt).inDays;
        if (daysDifference >= 0 && daysDifference < 7) {
          final dayIndex = completedAt.weekday;
          completedPerDay[dayIndex]++;
        }
      }
    }

    return completedPerDay;
  }
}


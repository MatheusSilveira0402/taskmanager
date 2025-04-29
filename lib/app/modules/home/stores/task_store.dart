import 'package:supabase_flutter/supabase_flutter.dart';

class TaskStore {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final userId = supabase.auth.currentUser!.id;
    return supabase
      .from('tasks')
      .select()
      .eq('user_id', userId)
      .order('status', ascending: false)
      .then((res) => res);
  }

  Future<void> addTask(String title, String description, bool completed) =>
    supabase.from('tasks').insert({
      'title': title,
      'description': description,
      'user_id': supabase.auth.currentUser!.id,
      'status': completed ? 'completed' : 'pending',
      'completed_at': completed ? DateTime.now().toIso8601String() : null,
      // status vem como 'pending' por default no banco
    });

  Future<void> updateTaskStatus(String id, bool completed) =>
    supabase.from('tasks').update({
      'status': completed ? 'completed' : 'pending',
      'completed_at': completed ? DateTime.now().toIso8601String() : null,
    }).eq('id', id);

  Future<void> updateTask(
    String id, {
    String? title,
    String? description,
    String? status,
  }) {
    final changes = <String, dynamic>{};
    if (title      != null) changes['title']       = title;
    if (description!= null) changes['description'] = description;
    if (status     != null) changes['status']      = status;
    if (status == 'completed') {
      changes['completed_at'] = DateTime.now().toIso8601String();
    } else if (status == 'pending') {
      changes['completed_at'] = null;
    }
    return supabase.from('tasks').update(changes).eq('id', id);
  }

  Future<void> deleteTask(String id) =>
    supabase.from('tasks').delete().eq('id', id);
}


import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager_app/app/modules/home/models/task_model.dart';

class TaskStore {
  final supabase = Supabase.instance.client;

  Future<List<TaskModel>> fetchTasks() async {
    final userId = supabase.auth.currentUser!.id;
    final response =
        await supabase
                .from('tasks')
                .select()
                .eq('user_id', userId)
                .order('scheduled_at', ascending: true)
                .order('status', ascending: true);

    return response.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<void> addTask(TaskModel task) async {
    return supabase.from('tasks').insert(task.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    return supabase.from('tasks').update(task.toMap()).eq('id', task.id);
  }

  Future<void> updateTaskStatus(String id, TaskStatus status) {
    return supabase
        .from('tasks')
        .update({
          'status': status.name,
          'completed_at':
              status == TaskStatus.completed ? DateTime.now().toIso8601String() : null,
        })
        .eq('id', id);
  }

  Future<List<TaskModel>> fetchDueTasks(DateTime now) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response =
        await supabase
                .from('tasks')
                .select()
                .eq('user_id', userId)
                .eq('status', TaskStatus.pending.name)
                .lte('scheduled_at', now.toIso8601String());

    return response.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<void> deleteTask(String id) async {
    return supabase.from('tasks').delete().eq('id', id);
  }
}

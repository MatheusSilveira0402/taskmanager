import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager_app/app/modules/home/models/task_model.dart';
import 'package:workmanager/workmanager.dart';

class TaskStore {
  final supabase = Supabase.instance.client;

  Future<List<TaskModel>> fetchTasks() async {
    final userId = supabase.auth.currentUser!.id;


    final response = await supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .order('scheduled_at', ascending: true)
        .order('status', ascending: true);

    return (response as List).map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<TaskModel> fetchOneTask(String id) async {
    final userId = supabase.auth.currentUser!.id;


    final response = await supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .eq('id', id);

    return TaskModel.fromMap(response.first);
  }

  Future<void> addTask(TaskModel task) async {
    await supabase.from('tasks').insert(task.toMap());
    await scheduleNotificationForTask(task);
  }

  Future<void> updateTask(TaskModel task) async {
    await supabase.from('tasks').update(task.toMap()).eq('id', task.id);
    await scheduleNotificationForTask(task);
  }

  Future<void> scheduleNotificationForTask(TaskModel task) async {
    if (task.scheduledAt == null) return;

    // Constrói o nome único da tarefa
    final uniqueName = 'task_${task.id}';

    // 1️⃣ Cancela qualquer instância antiga dessa tarefa
    await Workmanager().cancelByUniqueName(uniqueName);

    // 2️⃣ Calcula o delay até 10 minutos antes do scheduledAt
    final scheduledDate = task.scheduledAt!.subtract(const Duration(minutes: 10));
    final initialDelay = scheduledDate.isAfter(DateTime.now())
        ? scheduledDate.difference(DateTime.now())
        : Duration.zero;

    // 3️⃣ Registra a nova tarefa com o mesmo uniqueName
    await Workmanager().registerOneOffTask(
      uniqueName,
      'showNotification',
      initialDelay: initialDelay,
      inputData: {
        'taskId': task.id,
        'taskTitle': task.title,
      },
    );
  }

  Future<void> updateTaskStatus(String id, TaskStatus status) {
    return supabase.from('tasks').update({
      'status': status.name,
      'completed_at':
          status == TaskStatus.completed ? DateTime.now().toIso8601String() : null,
    }).eq('id', id);
  }

  Future<List<TaskModel>> fetchDueTasks(DateTime now) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabase
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

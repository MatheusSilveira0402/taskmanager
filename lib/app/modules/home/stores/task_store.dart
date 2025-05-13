import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager_app/app/modules/home/models/task_model.dart';
import 'package:workmanager/workmanager.dart';

/// `TaskStore` é responsável pela comunicação com o banco de dados (via Supabase) e gerenciamento das tarefas.
///
/// Essa classe inclui métodos para buscar, adicionar, atualizar e excluir tarefas, bem como para agendar notificações.
class TaskStore {
  final supabase = Supabase.instance.client;

  /// Busca todas as tarefas de um usuário, ordenadas pela data agendada e status.
  ///
  /// Retorna uma lista de objetos `TaskModel` correspondentes às tarefas do usuário.
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

  /// Busca uma tarefa específica pelo ID.
  ///
  /// Retorna um único objeto `TaskModel` correspondente à tarefa com o ID fornecido.
  Future<TaskModel> fetchOneTask(String id) async {
    final userId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .eq('id', id);

    return TaskModel.fromMap(response.first);
  }

  /// Adiciona uma nova tarefa ao banco de dados e agenda uma notificação para a tarefa.
  ///
  /// Após adicionar a tarefa, a função `scheduleNotificationForTask` é chamada para agendar a notificação.
  Future<void> addTask(TaskModel task) async {
    await supabase.from('tasks').insert(task.toMap());
    await scheduleNotificationForTask(task);
  }

  /// Atualiza uma tarefa existente no banco de dados e reprograma a notificação.
  ///
  /// Após atualizar a tarefa, a função `scheduleNotificationForTask` é chamada para reprogramar a notificação.
  Future<void> updateTask(TaskModel task) async {
    await supabase.from('tasks').update(task.toMap()).eq('id', task.id);
    await scheduleNotificationForTask(task);
  }

  /// Agenda uma notificação para a tarefa com base na data de agendamento.
  ///
  /// Calcula o delay necessário até 10 minutos antes da data de agendamento e registra a tarefa
  /// no `Workmanager` para mostrar a notificação na hora certa.
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

  /// Atualiza o status de uma tarefa no banco de dados.
  ///
  /// Se o status for `completed`, o campo `completed_at` é preenchido com o horário atual.
  Future<void> updateTaskStatus(String id, TaskStatus status) {
    return supabase.from('tasks').update({
      'status': status.name,
      'completed_at':
          status == TaskStatus.completed ? DateTime.now().toIso8601String() : null,
    }).eq('id', id);
  }

  /// Busca as tarefas pendentes que estão agendadas para execução até o momento atual.
  ///
  /// Retorna uma lista de tarefas que estão pendentes e cujo horário de agendamento já passou.
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

  /// Exclui uma tarefa do banco de dados.
  ///
  /// A tarefa é removida da tabela `tasks` com base no ID fornecido.
  Future<void> deleteTask(String id) async {
    return supabase.from('tasks').delete().eq('id', id);
  }
}

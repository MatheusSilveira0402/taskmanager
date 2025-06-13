import 'package:flutter/material.dart';
import 'package:task_manager_app/app/modules/home/models/task_model.dart';
import 'package:task_manager_app/app/modules/home/stores/task_store.dart';

/// `TaskProvider` é um provider que gerencia o estado e as operações relacionadas às tarefas.
/// Ele interage com o `TaskStore` para obter, adicionar, atualizar e excluir tarefas, além de gerenciar filtros de data e status.
class TaskProvider extends ChangeNotifier {
  final TaskStore _store;
  TaskProvider(this._store);

  // Lista de tarefas
  List<TaskModel> tasks = [];
  
  // Estado de carregamento
  bool loading = false;
  
  // ID da tarefa sendo atualizada
  String idUpdate = "";
  
  // Estado de carregamento individual para uma tarefa específica
  bool loadingIndividual = false;
  
  // Filtros de data e status
  DateTime? _selectedDate;
  TaskStatus? _selectedStatus;

  /// Getter para a data selecionada.
  DateTime? get selectedDate => _selectedDate;

  /// Getter para o status selecionado.
  TaskStatus? get selectedStatus => _selectedStatus;

  /// Define a data selecionada e notifica os ouvintes para atualizar a interface.
  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Define o status selecionado e notifica os ouvintes para atualizar a interface.
  void setSelectedStatus(TaskStatus? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  /// Filtra as tarefas com base na data e no status selecionado.
  ///
  /// Retorna uma lista de tarefas que correspondem aos filtros de data e status aplicados.
  List<TaskModel> get filteredTasks {
    return tasks.where((task) {
      final matchesStatus = _selectedStatus == null || task.status == _selectedStatus;
      final matchesDate = _selectedDate == null ||
          (task.scheduledAt != null &&
              task.scheduledAt!.year == _selectedDate!.year &&
              task.scheduledAt!.month == _selectedDate!.month &&
              task.scheduledAt!.day == _selectedDate!.day);
      return matchesStatus && matchesDate;
    }).toList();
  }

  /// Faz a requisição para buscar todas as tarefas e atualiza a lista de tarefas.
  ///
  /// Exibe o estado de carregamento enquanto a requisição está em andamento e, em seguida,
  /// notifica os ouvintes para que a interface seja atualizada com as tarefas obtidas.
  Future<void> fetchTasks() async {
    if (tasks.isNotEmpty) return;
    loading = true;
    notifyListeners();
  

    tasks = await _store.fetchTasks();

    loading = false;
    notifyListeners();
  }

  Future<void> fetchTasksAction() async {
    loading = true;
    notifyListeners();
  

    tasks = await _store.fetchTasks();

    loading = false;
    notifyListeners();
  }

  /// Adiciona uma nova tarefa ao banco de dados e atualiza a lista de tarefas.
  ///
  /// Após adicionar a tarefa, a lista de tarefas é recarregada para refletir as mudanças.
  Future<void> addTask(TaskModel task) async {
    await _store.addTask(task);
    await fetchTasksAction();
  }

  /// Atualiza os dados de uma tarefa existente e recarrega a lista de tarefas.
  ///
  /// Após atualizar a tarefa, a lista de tarefas é recarregada para refletir as mudanças.
  Future<void> updateTask(TaskModel task) async {
    await _store.updateTask(task);
    await fetchTasksAction();
  }

  /// Verifica e atualiza o status das tarefas pendentes conforme a data de agendamento.
  ///
  /// Caso a tarefa tenha o status "pendente" e a data agendada já tenha passado, ela é alterada para o status "em progresso".
  Future<void> checkAndUpdateTaskStatuses() async {
    final now = DateTime.now();
    for (TaskModel task in tasks) {
      if (task.status == TaskStatus.pending && task.scheduledAt != null) {
        final startTime = task.scheduledAt!.subtract(const Duration(seconds: 10));
        final shouldUpdateStatus = now.isAfter(startTime);
        if (shouldUpdateStatus) {
          task.status = TaskStatus.progress;
          await updateTaskStatus(task.id, task.status);
        }
      }
    }

    notifyListeners();
  }

  /// Atualiza o status de uma tarefa específica.
  ///
  /// O status da tarefa é alterado no banco de dados e na lista local, e a tarefa é recarregada para refletir o status atualizado.
  Future<void> updateTaskStatus(String id, TaskStatus status) async {
    loadingIndividual = true;
    idUpdate = id;
    notifyListeners();

    await _store.updateTaskStatus(id, status);

    final idx = tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      tasks[idx] = tasks[idx].copyWith(status: status);
      loadingIndividual = false;
      notifyListeners();

      final updatedTask = await _store.fetchOneTask(id);
      tasks[idx] = updatedTask;
      notifyListeners();
    }
  }

  /// Exclui uma tarefa da lista e do banco de dados.
  ///
  /// Após excluir a tarefa, a lista de tarefas é atualizada e o estado é notificado.
  Future<void> deleteTask(String id) async {
    await _store.deleteTask(id);
    tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}

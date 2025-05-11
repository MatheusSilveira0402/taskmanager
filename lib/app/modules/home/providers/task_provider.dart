import 'package:flutter/material.dart';
import 'package:task_manager_app/app/modules/home/models/task_model.dart';
import 'package:task_manager_app/app/modules/home/stores/task_store.dart';

class TaskProvider extends ChangeNotifier {
  final TaskStore _store;
  TaskProvider(this._store);

  List<TaskModel> tasks = [];
  bool loading = false;
  String idUpdate = "";
  bool loadingIndividual = false;
  DateTime? _selectedDate;
  TaskStatus? _selectedStatus;

  // Getters e setters dos filtros
  DateTime? get selectedDate => _selectedDate;
  TaskStatus? get selectedStatus => _selectedStatus;

  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedStatus(TaskStatus? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  List<TaskModel> get filteredTasks {
    // Se _selectedDate for null, retorna todas as tarefas, sem filtro de data
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

  Future<void> fetchTasks() async {
    loading = true;
    notifyListeners();

    tasks = await _store.fetchTasks();

    loading = false;
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    await _store.addTask(task);
    await fetchTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    await _store.updateTask(task);
    await fetchTasks();
  }

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

  Future<void> deleteTask(String id) async {
    await _store.deleteTask(id);
    tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}

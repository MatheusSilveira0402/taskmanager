import 'package:flutter/material.dart';
import 'package:task_manager_app/app/modules/home/models/task_model.dart';
import 'package:task_manager_app/app/modules/home/stores/task_store.dart';

class TaskProvider extends ChangeNotifier {
  final TaskStore _store;
  TaskProvider(this._store);

  List<TaskModel> tasks = [];
  bool loading = false;

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

  Future<void> updateTaskStatus(String id, TaskStatus status) async {
    final idx = tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      tasks[idx] = tasks[idx].copyWith(status: status);
      notifyListeners();
    }
    await _store.updateTaskStatus(id, status);
  }

  Future<void> deleteTask(String id) async {
    await _store.deleteTask(id);
    tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../stores/task_store.dart';

class TaskProvider extends ChangeNotifier {
  final TaskStore _store = TaskStore();
  List<Map<String, dynamic>> tasks = [];
  bool loading = false;

  Future<void> fetchTasks() async {
    loading = false;
    tasks = await _store.fetchTasks();
    loading = true;
    notifyListeners();
  }

  Future<void> addTask(String title, String description, bool completed) async {
    await _store.addTask(title, description, completed);
    await fetchTasks();
  }

  Future<void> updateTaskStatus(String id, bool completed) async {
    await _store.updateTaskStatus(id, completed);
    await fetchTasks();
  }

  Future<void> updateTask(
    String id, {
    String? title,
    String? description,
    String? status,
  }) async {
    await _store.updateTask(id, title: title, description: description, status: status);
    await fetchTasks();
  }

  Future<void> deleteTask(String id) async {
    await _store.deleteTask(id);
    await fetchTasks();
  }
}

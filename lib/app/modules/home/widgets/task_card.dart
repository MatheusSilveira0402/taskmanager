import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/modules/home/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final void Function(TaskStatus) onStatusChange;

  const TaskCard({super.key, required this.task, required this.onStatusChange});

  Color _getStatusColor(TaskStatus status) {
    const tealColor = Color(0xFF52B2AD);
    switch (status) {
      case TaskStatus.completed:
      case TaskStatus.progress:
        return tealColor;
      case TaskStatus.pending:
        return tealColor;
      case TaskStatus.delete:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return Icons.check;
      case TaskStatus.progress:
        return Icons.timelapse;
      case TaskStatus.pending:
        return Icons.radio_button_unchecked;
      case TaskStatus.delete:
        return Icons.delete_forever;
    }
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return 'Concluído';
      case TaskStatus.progress:
        return 'Em progresso';
      case TaskStatus.pending:
        return 'Pendente';
      case TaskStatus.delete:
        return 'Excluir';
    }
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final suffix = dt.hour >= 12 ? 'PM' : 'AM';
    final minutes = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minutes $suffix';
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        margin: EdgeInsets.zero,
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () => Modular.to.pushNamed('/main/home/taskform', arguments: task),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  final isCompleted = task.status == TaskStatus.completed;
                  final newStatus =
                      isCompleted ? TaskStatus.pending : TaskStatus.completed;
                  onStatusChange(newStatus);
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    key: ValueKey(task.status),
                    _getStatusIcon(task.status),
                    color: _getStatusColor(task.status),
                    size: 40,
                  ),
                ),
              ),
              // Título e status
              SizedBox(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    Text(
                      "${_getStatusText(task.status)} ${task.status == TaskStatus.completed ? _formatDate(task.completedAt):""}",
                      style: TextStyle(
                        color: _getStatusColor(task.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Data, hora e menu
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatDate(task.scheduledAt),
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                      ),
                      Text(
                        _formatTime(task.scheduledAt),
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                      ),
                    ],
                  ),
                  PopupMenuButton<TaskStatus>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: onStatusChange,
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: TaskStatus.pending,
                        child: Row(
                          children: [
                            const Icon(Icons.schedule, color: Colors.grey),
                            const SizedBox(width: 10),
                            Text(_getStatusText(TaskStatus.pending)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: TaskStatus.progress,
                        child: Row(
                          children: [
                            const Icon(Icons.autorenew, color: Colors.teal),
                            const SizedBox(width: 10),
                            Text(_getStatusText(TaskStatus.progress)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: TaskStatus.completed,
                        child: Row(
                          children: [
                            const Icon(Icons.check, color: Colors.green),
                            const SizedBox(width: 10),
                            Text(_getStatusText(TaskStatus.completed)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: TaskStatus.delete,
                        child: Row(
                          children: [
                            const Icon(Icons.delete_forever, color: Colors.red),
                            const SizedBox(width: 10),
                            Text(_getStatusText(TaskStatus.delete)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

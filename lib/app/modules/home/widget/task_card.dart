import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/home/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final void Function(TaskStatus) onStatusChange;

  const TaskCard({super.key, required this.task, required this.onStatusChange});

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.progress:
        return Colors.teal;
      case TaskStatus.pending:
        return Colors.grey;
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
    }
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final suffix = dt.hour >= 12 ? 'PM' : 'AM';
    final minutes = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minutes $suffix';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          leading: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Checkbox(
              key: ValueKey(task.status),
              value: task.status == TaskStatus.completed,
              onChanged: (checked) {
                final newStatus = checked! ? TaskStatus.completed : TaskStatus.pending;
                onStatusChange(newStatus);
              },
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration:
                  task.status == TaskStatus.completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
            ),
          ),
          subtitle: Text(
            _getStatusText(task.status),
            style: TextStyle(
              color: _getStatusColor(task.status),
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Horário
              Text(
                _formatTime(task.scheduledAt),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              // Menu de status
              PopupMenuButton<TaskStatus>(
                icon: const Icon(Icons.more_vert),
                onSelected: onStatusChange,
                itemBuilder:
                    (_) => [
                      PopupMenuItem(
                        value: TaskStatus.pending,
                        child: Row(
                          children: [
                            const Icon(Icons.schedule, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(_getStatusText(TaskStatus.pending)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: TaskStatus.progress,
                        child: Row(
                          children: [
                            const Icon(Icons.autorenew, color: Colors.teal),
                            const SizedBox(width: 8),
                            Text(_getStatusText(TaskStatus.progress)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: TaskStatus.completed,
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(_getStatusText(TaskStatus.completed)),
                          ],
                        ),
                      ),
                    ],
              ),
            ],
          ),
          onTap: () => Modular.to.pushNamed('/home/taskform', arguments: task),
        ),
      ),
    );
  }
}

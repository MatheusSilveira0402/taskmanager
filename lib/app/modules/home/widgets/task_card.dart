import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/modules/home/models/task_model.dart';

/// Um widget que exibe um cartão de tarefa com informações detalhadas.
///
/// O [TaskCard] exibe as informações de uma tarefa, incluindo o título, status,
/// data agendada e data de conclusão (se aplicável). Ele também permite que o
/// usuário altere o status da tarefa ao clicar no ícone de status ou ao selecionar
/// uma opção no menu de opções.
class TaskCard extends StatelessWidget {
  /// O modelo de tarefa exibido no cartão.
  final TaskModel task;

  /// Função de callback chamada quando o status da tarefa é alterado.
  final void Function(TaskStatus) onStatusChange;

  const TaskCard({super.key, required this.task, required this.onStatusChange});

  /// Retorna a cor associada a um status de tarefa.
  Color _getStatusColor(TaskStatus status) {
    const tealColor = Color(0xFF52B2AD);
    switch (status) {
      case TaskStatus.completed:
        return Colors.teal;
      case TaskStatus.progress:
        return tealColor;
      case TaskStatus.pending:
        return Colors.grey;
      case TaskStatus.delete:
        return Colors.grey;
    }
  }

  /// Retorna o ícone associado a um status de tarefa.
  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return Icons.check;
      case TaskStatus.progress:
        return Icons.autorenew;
      case TaskStatus.pending:
        return Icons.schedule;
      case TaskStatus.delete:
        return Icons.delete_forever;
    }
  }

  /// Retorna o texto associado a um status de tarefa.
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

  /// Formata a hora para o formato de 12 horas (AM/PM).
  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final suffix = dt.hour >= 12 ? 'PM' : 'AM';
    final minutes = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minutes $suffix';
  }

  /// Formata a data no formato dd/MM/yyyy.
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
          child: SizedBox(
            height: 50,
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ícone de status da tarefa
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(left: 15),
                  child: GestureDetector(
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
                        size: context.heightPct(0.055),
                      ),
                    ),
                  ),
                ),
                // Título e status da tarefa
                Container(
                  padding: const EdgeInsets.only(left: 5, top: 11),
                  width: context.widthPct(0.45),
                  height: 51,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: context.widthPct(0.42),
                            child: Text(
                              task.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: context.heightPct(0.0135),
                                  decoration: task.status == TaskStatus.completed
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${_getStatusText(task.status)}\n${task.status == TaskStatus.completed ? _formatDate(task.completedAt) : ""}",
                        style: TextStyle(
                            color: _getStatusColor(task.status),
                            fontWeight: FontWeight.bold,
                            fontSize: context.heightPct(0.013),
                            overflow: TextOverflow.fade),
                      ),
                    ],
                  ),
                ),
                // Data, hora e menu de opções
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatDate(task.scheduledAt),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: context.heightPct(0.013)),
                          ),
                          Text(
                            _formatTime(task.scheduledAt),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: context.heightPct(0.013)),
                          ),
                        ],
                      ),
                      PopupMenuButton<TaskStatus>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: onStatusChange,
                        offset: const Offset(0, -200),
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
                                const Icon(Icons.autorenew, color: Color(0xFF52B2AD)),
                                const SizedBox(width: 10),
                                Text(_getStatusText(TaskStatus.progress)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: TaskStatus.completed,
                            child: Row(
                              children: [
                                const Icon(Icons.check, color: Colors.teal),
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
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../providers/task_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TaskProvider taskProvider;

  @override
  void initState() {
    super.initState();
    taskProvider = context.read<TaskProvider>();
    taskProvider.fetchTasks(); // Carrega tarefas ao iniciar
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
      ),
      body: Builder(
        builder: (context) {
          if (provider.loading) {
            return Center(child: CircularProgressIndicator(),);
          }
          if (provider.tasks.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa.'));
          }

          return ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];

              return ListTile(
                leading: Checkbox(
                  value: task['status'] == 'completed',
                  onChanged: (checked) {
                    provider.updateTaskStatus(task['id'], checked!);
                  },
                ),
                title: Text(
                  task['title'],
                  style: TextStyle(
                    decoration: task['status'] == 'completed'
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task['description'] != null) Text(task['description']),
                    Text(
                      'Criada em: ${DateTime.parse(task['created_at']).toLocal().toString().split('.').first}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Confirmação'),
                        content: const Text('Deseja excluir esta tarefa?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Não'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Sim'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await provider.deleteTask(task['id']);
                    }
                  },
                ),
                onTap: () {
                  Modular.to.pushNamed('/home/taskform', arguments: task);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Modular.to.pushNamed('/home/taskform'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

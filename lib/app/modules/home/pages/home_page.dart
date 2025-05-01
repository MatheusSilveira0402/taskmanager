import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/home/widget/task_card.dart';
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
    taskProvider.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Tarefas Hoje"),
      ),
      body: Builder(
        builder: (context) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.tasks.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa.'));
          }
          return ListView.builder(
            itemCount: provider.tasks.length,
            itemExtent: 100.0, // Desempenho melhorado
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              return TaskCard(
                task: task,
                onStatusChange: (checked) {
                  provider.updateTaskStatus(task.id, checked);
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/modules/home/models/task_model.dart';
import 'package:task_manager_app/app/modules/home/widget/task_card.dart';
import 'package:task_manager_app/app/widgets/custom_date_picker_button.dart';
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
    Timer.periodic(const Duration(seconds: 10), (timer) {
      taskProvider.checkAndUpdateTaskStatuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(127, 82, 178, 173),
                  borderRadius: BorderRadius.circular(30)),
              height: MediaQuery.of(context).size.height / 3,
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 90,
                titleTextStyle: const TextStyle(fontSize: 40, color: Color(0xFF0f2429)),
                title: const Text("Tarefas"),
              ),
              Container(
                width: context.widthPct(1),
                margin: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 10.0,
                    children: [
                      CustomDatePickerButton(
                        selectedDate: provider.selectedDate,
                        onDateSelected: provider.setSelectedDate,
                        width: 120,
                        height: 40,
                      ),
                      FilterChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                        label: const Text('Pendente'),
                        selected: provider.selectedStatus == TaskStatus.pending,
                        onSelected: (_) => provider.setSelectedStatus(TaskStatus.pending),
                      ),
                      FilterChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                        label: const Text('Em progresso'),
                        selected: provider.selectedStatus == TaskStatus.progress,
                        onSelected: (_) =>
                            provider.setSelectedStatus(TaskStatus.progress),
                      ),
                      FilterChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                        label: const Text('Concluído'),
                        selected: provider.selectedStatus == TaskStatus.completed,
                        onSelected: (_) =>
                            provider.setSelectedStatus(TaskStatus.completed),
                      ),
                      FilterChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                        label: const Text('Todos'),
                        selected: provider.selectedStatus == null,
                        onSelected: (_) => provider.setSelectedStatus(null),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (provider.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final tasks = provider.filteredTasks;

                    if (tasks.isEmpty) {
                      return const Center(child: Text('Nenhuma tarefa encontrada.'));
                    }

                    return ListView.builder(
                      itemCount: tasks.length,
                      itemExtent: 100.0,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskCard(
                          task: task,
                          onStatusChange: (checked) {
                            if (checked == TaskStatus.delete) {
                              provider.deleteTask(task.id);
                            } else {
                              provider.updateTaskStatus(task.id, checked);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF52B2AD),
              foregroundColor: const Color(0xFF52B2AD),
              splashColor: const Color(0xFF52B2AD),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              onPressed: () => Modular.to.pushNamed('/main/home/taskform'),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

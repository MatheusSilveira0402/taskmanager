// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/core/log/debug_log.dart';
import 'package:task_manager_app/app/modules/home/models/task_model.dart';
import 'package:task_manager_app/app/modules/auth/providers/sign_out_provider.dart';
import 'package:task_manager_app/app/modules/home/widgets/task_card.dart';
import 'package:task_manager_app/app/modules/home/widgets/task_card_skeleton.dart';
import 'package:task_manager_app/app/widgets/custom_date_picker_button.dart';
import '../providers/task_provider.dart';

/// Página principal do aplicativo de gerenciamento de tarefas.
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (taskProvider.selectedDate == null) {
        taskProvider.setSelectedDate(DateTime.now());
      }
      taskProvider.fetchTasks();
      final startTime = DateTime.now();
      logDebug('[HOME] Chegou na home page $startTime');
      Timer.periodic(const Duration(seconds: 10), (timer) {
        taskProvider.checkAndUpdateTaskStatuses();
      });
    });
  }

  String _sortTypeLabel(TaskSortType type) {
    switch (type) {
      case TaskSortType.priority:
        return 'Prioridade';
      case TaskSortType.date:
        return 'Data';
      case TaskSortType.status:
        return 'Status';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final signOutProvider = context.watch<SignOutProvider>();

    return Scaffold(
      body: SizedBox(
        height: context.heightPct(1),
        child: Stack(
          children: [
            // Fundo decorativo da tela
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(127, 82, 178, 173),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30))),
                height: context.heightPct(0.4),
              ),
            ),
            Column(
              children: [
                // AppBar personalizada
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  toolbarHeight: context.heightPct(0.09),
                  scrolledUnderElevation: 0,
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                  actions: [
                    // Ícone de logout
                    IconButton(
                      icon: const Icon(Icons.logout, color: Color(0xFF0f2429)),
                      onPressed: () async {
                        // Realiza o logout do usuário e navega para a tela de login
                        await signOutProvider.signOut();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      },
                    ),
                  ],
                ),
                // Barra de filtros e seleção de data
                SingleChildScrollView(
                  child: Container(
                    width: context.widthPct(1),
                    height: context.heightPct(0.14),
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    padding: EdgeInsets.only(top: context.heightPct(0.030)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Botão de seleção de data
                                CustomDatePickerButton(
                                  selectedDate: provider.selectedDate,
                                  onDateSelected: provider.setSelectedDate,
                                  width: 80,
                                  height: 33,
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 33,
                                  child: TextButton(
                                      onPressed: () {
                                        provider.setSelectedDate(null);
                                      },
                                      child: Text(
                                        "Periodo todo",
                                        style: TextStyle(
                                            color: const Color(0xFF00695c),
                                            fontSize: context.heightPct(0.012)),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          // Filtro de status de tarefas (Todos, Pendente, Em progresso, Concluído)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              FilterChip(
                                showCheckmark: false,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(color: Colors.transparent),
                                ),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 4,
                                  children: [
                                    Icon(
                                      Icons.filter_list,
                                      size: context.heightPct(0.017),
                                    ),
                                    Text(
                                      'Todos',
                                      style:
                                          TextStyle(fontSize: context.heightPct(0.012)),
                                    ),
                                  ],
                                ),
                                selected: provider.selectedStatus == null,
                                onSelected: (_) => provider.setSelectedStatus(null),
                              ),
                              FilterChip(
                                showCheckmark: false,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(color: Colors.transparent),
                                ),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 4,
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      color: Colors.grey,
                                      size: context.heightPct(0.017),
                                    ),
                                    Text(
                                      'Pendente',
                                      style:
                                          TextStyle(fontSize: context.heightPct(0.012)),
                                    ),
                                  ],
                                ),
                                selected: provider.selectedStatus == TaskStatus.pending,
                                onSelected: (_) =>
                                    provider.setSelectedStatus(TaskStatus.pending),
                              ),
                              FilterChip(
                                showCheckmark: false,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(color: Colors.transparent),
                                ),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 4,
                                  children: [
                                    Icon(
                                      Icons.autorenew,
                                      color: const Color(0xFF52B2AD),
                                      size: context.heightPct(0.017),
                                    ),
                                    Text(
                                      'Em progresso',
                                      style:
                                          TextStyle(fontSize: context.heightPct(0.012)),
                                    ),
                                  ],
                                ),
                                selected: provider.selectedStatus == TaskStatus.progress,
                                onSelected: (_) =>
                                    provider.setSelectedStatus(TaskStatus.progress),
                              ),
                              FilterChip(
                                showCheckmark: false,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(color: Colors.transparent),
                                ),
                                label: Row(
                                  spacing: 4,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check,
                                        color: Colors.teal,
                                        size: context.heightPct(0.017)),
                                    Text(
                                      'Concluído',
                                      style:
                                          TextStyle(fontSize: context.heightPct(0.012)),
                                    ),
                                  ],
                                ),
                                selected: provider.selectedStatus == TaskStatus.completed,
                                onSelected: (_) =>
                                    provider.setSelectedStatus(TaskStatus.completed),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, bottom: 2),
                  height: context.heightPct(0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilterChip(
                        elevation: 4,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.sort,
                                color: Colors.black54, size: context.heightPct(0.017)),
                            const SizedBox(width: 4),
                            Text(
                              _sortTypeLabel(provider.sortType),
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: context.heightPct(0.012)),
                            ),
                          ],
                        ),
                        selected: false,
                        onSelected: (_) {
                          showMenu<TaskSortType>(
                            context: context,
                            position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                            items: [
                              PopupMenuItem(
                                height: 36,
                                value: TaskSortType.priority,
                                child: Row(
                                  spacing: 2,
                                  children: [
                                    Icon(Icons.flag, size: context.heightPct(0.017), color: Colors.teal),
                                    Text(
                                      'Prioridade',
                                      style:
                                          TextStyle(fontSize: context.heightPct(0.015)),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                height: 36,
                                value: TaskSortType.date,
                                child: Row(
                                  spacing: 2,
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: context.heightPct(0.017), color: Colors.teal),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Data',
                                      style:
                                          TextStyle(fontSize: context.heightPct(0.015)),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                height: 36,
                                value: TaskSortType.status,
                                child: Row(
                                  spacing: 2,
                                  children: [
                                    Icon(Icons.check_circle,
                                        size: context.heightPct(0.017), color: Colors.teal),
                                    Text(
                                      'Status',
                                      style:
                                          TextStyle(fontSize: context.heightPct(0.015)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ).then((value) {
                            if (value != null) {
                              provider.setSortType(value);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Exibição das tarefas (com carregamento e skeletons
                Container(
                  height: context.heightPct(0.59),
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.only(bottom: context.heightPct(0.023)),
                  child: Builder(
                    builder: (context) {
                      // Caso as tarefas ainda estejam sendo carregadas, exibe skeletons
                      if (provider.loading) {
                        return ListView.builder(
                          itemCount: 6, // mostra 6 placeholders enquanto carrega
                          itemExtent: 100.0,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) => const TaskCardSkeleton(),
                        );
                      }
                      final tasks = provider.filteredTasks;

                      // Caso não haja tarefas, exibe uma mensagem
                      if (tasks.isEmpty) {
                        return const Center(child: Text('Nenhuma tarefa encontrada.'));
                      }

                      // Exibe a lista de tarefas
                      return ListView.builder(
                        itemCount: tasks.length,
                        itemExtent: 110.0, // Pode ser ajustado conforme necessário
                        padding: EdgeInsets.zero, // Remove o padding da lista
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          // Caso a tarefa esteja sendo atualizada, exibe um skeleton
                          if (provider.loadingIndividual &&
                              task.id == provider.idUpdate) {
                            return const TaskCardSkeleton();
                          }
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
                )
              ],
            ),
            // Botão flutuante para adicionar novas tarefas
            Positioned(
              bottom: context.heightPct(0.1) + 5,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFF52B2AD),
                foregroundColor: const Color(0xFF52B2AD),
                splashColor: const Color(0xFF52B2AD),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                onPressed: () => Modular.to.pushNamed('/main/home/taskform'),
                child: const Icon(Icons.add_task, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

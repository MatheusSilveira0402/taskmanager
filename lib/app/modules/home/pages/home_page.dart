// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
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

    // Inicializa o TaskProvider e configura a data selecionada (se não houver uma).
    taskProvider = context.read<TaskProvider>();
    if (taskProvider.selectedDate == null) {
      taskProvider.setSelectedDate(DateTime.now());
    }
    // Faz a requisição das tarefas ao iniciar a página.
    taskProvider.fetchTasks();

    // Verifica e atualiza o status das tarefas a cada 10 segundos.
    Timer.periodic(const Duration(seconds: 10), (timer) {
      taskProvider.checkAndUpdateTaskStatuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final signOutProvider = context.watch<SignOutProvider>();

    return Scaffold(
      body: Stack(
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
                      bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
              height: context.heightPct(0.4) - 60,
            ),
          ),
          Column(
            spacing: 18.0,
            children: [
              // AppBar personalizada
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 90,
                titleTextStyle: const TextStyle(fontSize: 40, color: Color(0xFF0f2429)),
                title: const Text("Tarefas"),
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
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      height: 90,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10.0,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Botão de seleção de data
                              CustomDatePickerButton(
                                selectedDate: provider.selectedDate,
                                onDateSelected: provider.setSelectedDate,
                                width: 120,
                              ),
                              SizedBox(
                                height: 40,
                                child: TextButton(
                                    onPressed: () {
                                      provider.setSelectedDate(null);
                                    },
                                    child: const Text(
                                      "Periodo todo",
                                      style: TextStyle(color: Color(0xFF00695c)),
                                    )),
                              )
                            ],
                          ),
                          // Filtro de status de tarefas (Pendente, Em progresso, Concluído, Todos)
                          FilterChip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(color: Colors.transparent),
                            ),
                            label: const Text('Pendente'),
                            selected: provider.selectedStatus == TaskStatus.pending,
                            onSelected: (_) =>
                                provider.setSelectedStatus(TaskStatus.pending),
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
                ),
              ),
              // Exibição das tarefas (com carregamento e skeletons)
              Container(
                height: context.heightPct(0.6) + 30,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
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
                        if (provider.loadingIndividual && task.id == provider.idUpdate) {
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

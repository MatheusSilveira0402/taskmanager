// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/modules/home/models/task_model.dart';
import 'package:task_manager_app/app/modules/home/providers/task_provider.dart';
import 'package:task_manager_app/app/modules/home/widgets/custom_date_picker_input.dart';
import 'package:task_manager_app/app/widgets/custom_button.dart';
import 'package:task_manager_app/app/widgets/custom_dropdown.dart';
import 'package:task_manager_app/app/widgets/custom_text_field.dart';

// Página de criação e edição de tarefas
class TaskFormPage extends StatefulWidget {
  const TaskFormPage({
    super.key,
  });

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  late TaskProvider taskProvider; // Provedor de tarefas
  final _formKey = GlobalKey<FormState>(); // Chave global para o formulário

  // Controladores de texto para os campos do formulário
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  // Variáveis para armazenar as seleções de status, prioridade e data agendada da tarefa
  late TaskStatus _status;
  late TaskPriority _priority;
  DateTime? _scheduledAt;

  TaskModel? task; // Tarefa (caso esteja editando uma existente)

  @override
  void initState() {
    super.initState();
    task = Modular.args.data; // Obtém a tarefa (caso esteja editando)

    // Inicializa os controladores com os valores da tarefa existente ou com valores padrões
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _status = task?.status ?? TaskStatus.pending;
    _priority = task?.priority ?? TaskPriority.medium;
    _scheduledAt = task?.scheduledAt;
  }

  @override
  void dispose() {
    _titleController.dispose(); // Libera o controlador do título
    _descriptionController.dispose(); // Libera o controlador da descrição
    super.dispose();
  }

  // Função para salvar ou atualizar a tarefa
  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      // Valida os campos do formulário
      final currentUser =
          Supabase.instance.client.auth.currentUser; // Obtém o usuário atual

      if (currentUser == null) {
        // Caso não haja um usuário logado
        return;
      }

      final userId = currentUser.id; // Obtém o ID do usuário logado

      // Cria um modelo de tarefa com os valores do formulário
      final model = TaskModel(
        id: task?.id ?? '', // Se for uma nova tarefa, o ID é vazio
        userId: userId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        status: _status,
        priority: _priority,
        createdAt: task?.createdAt,
        completedAt: _status == TaskStatus.completed ? DateTime.now() : task?.completedAt,
        scheduledAt: _scheduledAt,
      );

      // Adiciona ou atualiza a tarefa dependendo se é uma nova ou existente
      if (task == null) {
        await taskProvider.addTask(model); // Adiciona tarefa
      } else {
        await taskProvider.updateTask(model); // Atualiza tarefa existente
      }

      if (!context.mounted) return; // Verifica se o contexto ainda está montado
      Navigator.of(context).pop(); // Volta para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    taskProvider = context.watch<TaskProvider>(); // Obtém o provedor de tarefas
    final isEditing = task != null; // Verifica se está editando uma tarefa existente

    return Scaffold(
      body: Stack(
        children: [
          // Fundo com gradiente e bordas arredondadas
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(127, 82, 178, 173),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
              height: context.heightPct(0.4), // Altura ajustável
            ),
          ),
          Column(
            spacing: 18,
            children: [
              // Barra de navegação superior com título e configuração de fundo transparente
              SizedBox(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  toolbarHeight: context.heightPct(0.1),
                  titleTextStyle: const TextStyle(fontSize: 40, color: Color(0xFF0f2429)),
                  title: Text(isEditing ? 'Editar Tarefa' : 'Nova Tarefa'),
                ),
              ),
              // Formulário de criação/edição de tarefa
              SingleChildScrollView(
                child: Container(
                  height: context.heightPct(0.7),
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: Form(
                    key: _formKey, // Associa o formulário à chave
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20.0,
                      children: [
                        // Campo de título da tarefa
                        CustomTextField(
                          controller: _titleController,
                          label: 'Título',
                          icon: Icons.title_outlined,
                          validator: (v) =>
                              (v?.trim().isEmpty ?? true) ? 'Informe o título' : null,
                        ),
                        // Campo de descrição da tarefa
                        CustomTextField(
                          controller: _descriptionController,
                          label: 'Descrição',
                          icon: Icons.description,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um Descrição';
                            }
                            return null;
                          },
                        ),
                        // Campo de seleção de status
                        CustomDropdown<TaskStatus>(
                          label: 'Status',
                          value: _status,
                          items: TaskStatus.values
                              .where((st) => st != TaskStatus.delete)
                              .map(
                                (st) => DropdownMenuItem(
                                  value: st,
                                  child: Text(st.value.capitalize()),
                                ),
                              )
                              .toList(),
                          onChanged: (st) => setState(() => _status = st!),
                        ),
                        // Campo de seleção de prioridade
                        CustomDropdown<TaskPriority>(
                          label: 'Prioridade',
                          value: _priority,
                          items: TaskPriority.values
                              .map(
                                (p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p.value.capitalize()),
                                ),
                              )
                              .toList(),
                          onChanged: (p) => setState(() => _priority = p!),
                        ),
                        // Campo de seleção de data agendada
                        CustomDatePickerInput(
                          selectedDate: _scheduledAt,
                          onDateSelected: (pickedDateTime) {
                            setState(() => _scheduledAt = pickedDateTime);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor, selecione uma data';
                            }
                            return null;
                          },
                        ),
                        // Botão de salvar tarefa
                        CustomButton(
                          text: 'Salvar Tarefa',
                          onPressed: _saveTask,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Extensão para capitalizar a primeira letra de uma string
extension StringCap on String {
  String capitalize() => isEmpty ? this : substring(0, 1).toUpperCase() + substring(1);
}

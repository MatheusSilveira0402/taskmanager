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

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({
    super.key,
  });

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  late TaskProvider taskProvider;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskStatus _status;
  late TaskPriority _priority;
  DateTime? _scheduledAt;
  TaskModel? task;

  @override
  void initState() {
    super.initState();
    task = Modular.args.data;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _status = task?.status ?? TaskStatus.pending;
    _priority = task?.priority ?? TaskPriority.medium;
    _scheduledAt = task?.scheduledAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    print("_scheduledAt: $_scheduledAt");
    if (_formKey.currentState!.validate()) {
      final currentUser = Supabase.instance.client.auth.currentUser;

      if (currentUser == null) {
        return;
      }

      final userId = currentUser.id;
      final model = TaskModel(
        id: task?.id ?? '', // Se criar, deixamos em branco
        userId: userId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        status: _status,
        priority: _priority,
        createdAt: task?.createdAt,
        completedAt: _status == TaskStatus.completed ? DateTime.now() : task?.completedAt,
        scheduledAt: _scheduledAt,
      );

      if (task == null) {
        await taskProvider.addTask(model);
      } else {
        await taskProvider.updateTask(model);
      }
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {

    taskProvider = context.watch<TaskProvider>();
    final isEditing = task != null;
    return Scaffold(
      body: Stack(
        children: [
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
            spacing: 18,
            children: [
              SizedBox(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  toolbarHeight: 90,
                  titleTextStyle: const TextStyle(fontSize: 40, color: Color(0xFF0f2429)),
                  title: Text(isEditing ? 'Editar Tarefa' : 'Nova Tarefa'),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  height: context.heightPct(0.6),
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20.0,
                      children: [
                        CustomTextField(
                          controller: _titleController,
                          label: 'Título',
                          icon: Icons.title_outlined,
                          validator: (v) =>
                              (v?.trim().isEmpty ?? true) ? 'Informe o título' : null,
                        ),
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

extension StringCap on String {
  String capitalize() => isEmpty ? this : substring(0, 1).toUpperCase() + substring(1);
}

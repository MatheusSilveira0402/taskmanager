import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager_app/app/modules/home/models/task_model.dart';
import 'package:task_manager_app/app/modules/home/providers/task_provider.dart';

class TaskFormPage extends StatefulWidget {

  const TaskFormPage({super.key,});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  late final TaskProvider taskProvider;
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
    taskProvider = Modular.get<TaskProvider>();
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

  Future<void> _selectScheduledAt() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    // ignore: use_build_context_synchronously
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt ?? DateTime.now()),
    );
    if (time == null) return;

    setState(() {
      _scheduledAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _saveTask() async {
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
      completedAt:
          _status == TaskStatus.completed ? DateTime.now() : task?.completedAt,
      scheduledAt: _scheduledAt,
    );

    if (task == null) {
      await taskProvider.addTask(model);
    } else {
      await taskProvider.updateTask(model);
    }
    Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = task != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Tarefa' : 'Nova Tarefa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => (v?.trim().isEmpty ?? true) ? 'Informe o título' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskStatus>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items:
                    TaskStatus.values
                        .map(
                          (st) => DropdownMenuItem(
                            value: st,
                            child: Text(st.value.capitalize()),
                          ),
                        )
                        .toList(),
                onChanged: (st) => setState(() => _status = st!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskPriority>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Prioridade'),
                items:
                    TaskPriority.values
                        .map(
                          (p) => DropdownMenuItem(
                            value: p,
                            child: Text(p.value.capitalize()),
                          ),
                        )
                        .toList(),
                onChanged: (p) => setState(() => _priority = p!),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _scheduledAt != null
                      ? 'Agendada para: ${_scheduledAt!.toLocal().toString().split('.').first}'
                      : 'Selecionar data/hora',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectScheduledAt,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveTask,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringCap on String {
  String capitalize() => isEmpty ? this : substring(0, 1).toUpperCase() + substring(1);
}

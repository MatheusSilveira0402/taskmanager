import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/home/providers/task_provider.dart';

import '../stores/task_store.dart';

// ignore: must_be_immutable
class TaskFormPage extends StatefulWidget {
  late Map<String, dynamic>? task;

  TaskFormPage({
    super.key,
    this.task,
  });

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final taskProvider = Modular.get<TaskProvider>();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _completed = widget.task?['status'] == 'completed';
    widget.task = Modular.args.data;
    titleController =
        TextEditingController(text: widget.task?['title'] ?? '');
    descriptionController =
        TextEditingController(text: widget.task?['description'] ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

   Future<void> _saveTask() async {
    final title = titleController.text;
    final desc  = descriptionController.text;
    if (widget.task == null) {
       await taskProvider.addTask(title, desc, _completed);
    } else {
      await taskProvider.updateTask(
        widget.task!['id'],
        title: title,
        description: desc,
        status: _completed ? 'completed' : 'pending',
      );
    }
    Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Tarefa' : 'Nova Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
               CheckboxListTile(
              title: const Text('Concluída'),
              value: _completed,
              onChanged: (val) => setState(() => _completed = val!),
            ),
              const SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: _saveTask,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

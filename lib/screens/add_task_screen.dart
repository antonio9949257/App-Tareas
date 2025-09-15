import 'package:flutter/material.dart';
import '../models/task.dart'; // Import the Task model to use enums

class AddTaskScreen extends StatefulWidget {
  final Function(Task) onAddTask;
  final TaskAssignmentType initialAssignmentType;

  const AddTaskScreen({Key? key, required this.onAddTask, required this.initialAssignmentType}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _textController = TextEditingController();
  TaskType _selectedTaskType = TaskType.other;
  TaskCategory _selectedCategory = TaskCategory.other;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Título de la tarea',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tipo de Tarea:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            DropdownButton<TaskType>(
              value: _selectedTaskType,
              onChanged: (TaskType? newValue) {
                setState(() {
                  _selectedTaskType = newValue!;
                });
              },
              items: TaskType.values.map<DropdownMenuItem<TaskType>>((TaskType type) {
                return DropdownMenuItem<TaskType>(
                  value: type,
                  child: Text(type.toString().split('.').last), // Display enum name
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Categoría:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            DropdownButton<TaskCategory>(
              value: _selectedCategory,
              onChanged: (TaskCategory? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: TaskCategory.values.map<DropdownMenuItem<TaskCategory>>((TaskCategory category) {
                return DropdownMenuItem<TaskCategory>(
                  value: category,
                  child: Text(category.toString().split('.').last), // Display enum name
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final title = _textController.text;
                  if (title.isNotEmpty) {
                    final newTask = Task(
                      id: DateTime.now().toString(),
                      title: title,
                      taskType: _selectedTaskType,
                      category: _selectedCategory,
                      assignmentType: widget.initialAssignmentType,
                    );
                    widget.onAddTask(newTask);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
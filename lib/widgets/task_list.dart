import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_tile.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(int, bool) onTaskCompletionChanged;
  final Function(int) onTaskDismissed;
  final Function(Task) onTaskUpdated;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onTaskCompletionChanged,
    required this.onTaskDismissed,
    required this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskTile(
          task: task,
          onCheckboxChanged: (value) {
            onTaskCompletionChanged(index, value ?? false);
          },
          onDismissed: (direction) {
            onTaskDismissed(index);
          },
          onTaskUpdated: (updatedTask) {
            onTaskUpdated(updatedTask);
          },
        );
      },
    );
  }
}

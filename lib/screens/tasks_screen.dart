import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_list.dart';

class TasksScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(int, bool) onTaskCompletionChanged;
  final Function(int) onTaskDismissed;
  final Function(Task) onTaskUpdated;

  const TasksScreen({
    super.key,
    required this.tasks,
    required this.onTaskCompletionChanged,
    required this.onTaskDismissed,
    required this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return TaskList(
      tasks: tasks,
      onTaskCompletionChanged: onTaskCompletionChanged,
      onTaskDismissed: onTaskDismissed,
      onTaskUpdated: onTaskUpdated,
    );
  }
}
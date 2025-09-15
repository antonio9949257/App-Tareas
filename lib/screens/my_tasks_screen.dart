import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_list.dart';

class MyTasksScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(int, bool) onTaskCompletionChanged;
  final Function(int) onTaskDismissed;
  final Function(Task) onTaskUpdated;

  const MyTasksScreen({
    super.key,
    required this.tasks,
    required this.onTaskCompletionChanged,
    required this.onTaskDismissed,
    required this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final myTasks = tasks.where((task) => task.assignmentType != null && task.assignmentType == TaskAssignmentType.mine).toList();

    return TaskList(
      tasks: myTasks,
      onTaskCompletionChanged: onTaskCompletionChanged,
      onTaskDismissed: onTaskDismissed,
      onTaskUpdated: onTaskUpdated,
    );
  }
}

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_list.dart';

class AssignedTasksScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(int, bool) onTaskCompletionChanged;
  final Function(int) onTaskDismissed;
  final Function(Task) onTaskUpdated;

  const AssignedTasksScreen({
    super.key,
    required this.tasks,
    required this.onTaskCompletionChanged,
    required this.onTaskDismissed,
    required this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final assignedTasks = tasks.where((task) => task.assignmentType != null && task.assignmentType == TaskAssignmentType.assigned).toList();

    return TaskList(
      tasks: assignedTasks,
      onTaskCompletionChanged: onTaskCompletionChanged,
      onTaskDismissed: onTaskDismissed,
      onTaskUpdated: onTaskUpdated,
    );
  }
}

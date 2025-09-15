import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/task_details_screen.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(bool?)? onCheckboxChanged;
  final Function(DismissDirection)? onDismissed;
  final Function(Task) onTaskUpdated;

  const TaskTile({
    super.key,
    required this.task,
    required this.onCheckboxChanged,
    required this.onDismissed,
    required this.onTaskUpdated,
  });

  void _navigateToTaskDetailsScreen(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(task: task),
      ),
    );

    if (result != null && result is Task) {
      onTaskUpdated(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Dismissible(
        key: Key(task.id),
        onDismissed: onDismissed,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        child: Card(
          child: ListTile(
            onTap: () => _navigateToTaskDetailsScreen(context),
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: onCheckboxChanged,
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (task.pomodoroStatus == PomodoroStatus.running)
                  const Icon(Icons.timer, color: Colors.green),
                if (task.pomodoroStatus == PomodoroStatus.paused)
                  const Icon(Icons.pause, color: Colors.orange),
                Text('${task.pomodoroCount} Pomodoros'),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
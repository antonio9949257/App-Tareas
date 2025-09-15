enum PomodoroStatus { stopped, running, paused }
enum PomodoroType { standard, flexible }

enum TaskAssignmentType { mine, assigned }

enum TaskType {
  practicoLab,
  simulacionLab,
  ejerciciosPractica,
  lecturaComprensivaProfunda,
  soporteInstalacion,
  other,
}

enum TaskCategory {
  hardware,
  software,
  mecanico,
  other,
}

class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final int pomodoroCount;
  final PomodoroStatus pomodoroStatus;
  final DateTime? pomodoroStartTime;
  final List<String> logs;
  final PomodoroType pomodoroType;
  final TaskType taskType;
  final TaskCategory category;
  final TaskAssignmentType assignmentType;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.pomodoroCount = 0,
    this.pomodoroStatus = PomodoroStatus.stopped,
    this.pomodoroStartTime,
    this.logs = const [],
    this.pomodoroType = PomodoroType.standard,
    this.taskType = TaskType.other,
    this.category = TaskCategory.other,
    this.assignmentType = TaskAssignmentType.mine,
  });

  // Convert a Task object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
      'pomodoroCount': pomodoroCount,
      'pomodoroStatus': pomodoroStatus.index,
      'pomodoroStartTime': pomodoroStartTime?.toIso8601String(),
      'logs': logs.join(','), // Store logs as a comma-separated string
      'pomodoroType': pomodoroType.index,
      'taskType': taskType.index,
      'category': category.index,
      'assignmentType': assignmentType.index,
    };
  }

  // Extract a Task object from a Map object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'] == 1 ? true : false,
      pomodoroCount: map['pomodoroCount'],
      pomodoroStatus: PomodoroStatus.values[map['pomodoroStatus']],
      pomodoroStartTime: map['pomodoroStartTime'] != null
          ? DateTime.parse(map['pomodoroStartTime'])
          : null,
      logs: map['logs'] != null && map['logs'].isNotEmpty
          ? (map['logs'] as String).split(',')
          : [],
      pomodoroType: PomodoroType.values[map['pomodoroType']],
      taskType: TaskType.values[map['taskType']],
      category: TaskCategory.values[map['category']],
      assignmentType: TaskAssignmentType.values[map['assignmentType']],
    );
  }

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    int? pomodoroCount,
    PomodoroStatus? pomodoroStatus,
    DateTime? pomodoroStartTime,
    List<String>? logs,
    PomodoroType? pomodoroType,
    TaskType? taskType,
    TaskCategory? category,
    TaskAssignmentType? assignmentType,
    bool forcePomodoroStartTimeToNull = false,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      pomodoroCount: pomodoroCount ?? this.pomodoroCount,
      pomodoroStatus: pomodoroStatus ?? this.pomodoroStatus,
      pomodoroStartTime: forcePomodoroStartTimeToNull
          ? null
          : pomodoroStartTime ?? this.pomodoroStartTime,
      logs: logs ?? this.logs,
      pomodoroType: pomodoroType ?? this.pomodoroType,
      taskType: taskType ?? this.taskType,
      category: category ?? this.category,
      assignmentType: assignmentType ?? this.assignmentType,
    );
  }
}

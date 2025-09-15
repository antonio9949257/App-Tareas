import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late Task _task;
  Timer? _timer;
  Duration _duration = const Duration(minutes: 25);
  final _logTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    if (_task.pomodoroStatus == PomodoroStatus.running) {
      if (_task.pomodoroType == PomodoroType.standard) {
        _duration = const Duration(minutes: 25) -
            DateTime.now().difference(_task.pomodoroStartTime!);
      } else {
        _duration = DateTime.now().difference(_task.pomodoroStartTime!);
      }
      _startTimer();
    } else {
      if (_task.pomodoroType == PomodoroType.standard) {
        _duration = const Duration(minutes: 25);
      } else {
        _duration = Duration.zero; // Flexible starts from 0
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _logTextController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_task.pomodoroType == PomodoroType.standard) {
          _duration = _duration - const Duration(seconds: 1);
        } else {
          _duration = _duration + const Duration(seconds: 1);
        }
      });

      if (_task.pomodoroType == PomodoroType.standard) {
        if (_duration.inSeconds <= 0) {
          _stopTimer(completed: true);
          _showPomodoroCompletedDialog();
        }
      }
      // Flexible Pomodoro notifications and max limit
      else {
        if (_duration.inMinutes == 30 && _duration.inSeconds == 0) {
          _showFlexiblePomodoroNotification('¡Llevas 30 minutos!');
        } else if (_duration.inHours == 1 && _duration.inMinutes.remainder(60) == 0 && _duration.inSeconds == 0) {
          _showFlexiblePomodoroNotification('¡Llevas 1 hora!');
        } else if (_duration.inHours == 1 && _duration.inMinutes.remainder(60) == 30 && _duration.inSeconds == 0) {
          _showFlexiblePomodoroNotification('¡Llevas 1 hora y 30 minutos!');
          _stopTimer(completed: true); // Stop at 1h 30m
        }
      }
    });
  }

  void _showPomodoroCompletedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Pomodoro Completado!'),
        content: const Text('¡Buen trabajo! Tómate un merecido descanso.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFlexiblePomodoroNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _task = _task.copyWith(pomodoroStatus: PomodoroStatus.paused);
    });
  }

  void _stopTimer({bool completed = false}) {
    _timer?.cancel();
    setState(() {
      _task = _task.copyWith(
        pomodoroStatus: PomodoroStatus.stopped,
        pomodoroCount: completed ? _task.pomodoroCount + 1 : _task.pomodoroCount,
        forcePomodoroStartTimeToNull: true,
      );
      if (_task.pomodoroType == PomodoroType.standard) {
        _duration = const Duration(minutes: 25);
      } else {
        _duration = Duration.zero;
      }
    });
  }

  void _handlePlayButton() {
    if (_task.pomodoroStatus == PomodoroStatus.running) {
      _pauseTimer();
    } else {
      setState(() {
        _task = _task.copyWith(
          pomodoroStatus: PomodoroStatus.running,
          pomodoroStartTime: DateTime.now(),
        );
      });
      _startTimer();
    }
  }

  void _addLog() {
    if (_logTextController.text.isNotEmpty) {
      setState(() {
        _task = _task.copyWith(
          logs: [..._task.logs, _logTextController.text],
        );
        _logTextController.clear();
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_task);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_task.title),
        ),
        body: SingleChildScrollView( // Added SingleChildScrollView here
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pomodoro Type Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tipo de Pomodoro:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text('Estándar (25 min)'),
                        selected: _task.pomodoroType == PomodoroType.standard,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _task = _task.copyWith(pomodoroType: PomodoroType.standard);
                              _duration = const Duration(minutes: 25);
                              _stopTimer(); // Reset timer when type changes
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text('Flexible'),
                        selected: _task.pomodoroType == PomodoroType.flexible,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _task = _task.copyWith(pomodoroType: PomodoroType.flexible);
                              _duration = Duration.zero; // Flexible starts from 0
                              _stopTimer(); // Reset timer when type changes
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Pomodoro Section
              Center(
                child: Column(
                  children: [
                    Text(
                      _formatDuration(_duration),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 60,
                          icon: Icon(
                            _task.pomodoroStatus == PomodoroStatus.running
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                          ),
                          onPressed: _handlePlayButton,
                        ),
                        if (_task.pomodoroStatus != PomodoroStatus.stopped)
                          IconButton(
                            iconSize: 60,
                            icon: const Icon(Icons.stop_circle),
                            onPressed: () => _stopTimer(),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Logs Section
              Text(
                'Bitácora',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              SizedBox( // Added SizedBox to give ListView a bounded height
                height: 200, // Adjust height as needed
                child: ListView.builder(
                  itemCount: _task.logs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_task.logs[index]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _logTextController,
                      decoration: const InputDecoration(
                        labelText: 'Nueva entrada en la bitácora',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addLog,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

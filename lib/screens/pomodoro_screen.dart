import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task.dart';

class PomodoroScreen extends StatefulWidget {
  final Task task;

  const PomodoroScreen({super.key, required this.task});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  Timer? _timer;
  Duration _duration = const Duration(minutes: 25);
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    if (_task.pomodoroStatus == PomodoroStatus.running) {
      _duration = const Duration(minutes: 25) -
          DateTime.now().difference(_task.pomodoroStartTime!);
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _duration = _duration - const Duration(seconds: 1);
      });
      if (_duration.inSeconds <= 0) {
        _stopTimer(completed: true);
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
    });
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
      _duration = const Duration(minutes: 25);
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
          title: Text('Pomodoro: ${_task.title}'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    iconSize: 80,
                    icon: Icon(
                      _task.pomodoroStatus == PomodoroStatus.running
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                    ),
                    onPressed: _handlePlayButton,
                  ),
                  if (_task.pomodoroStatus != PomodoroStatus.stopped)
                    IconButton(
                      iconSize: 80,
                      icon: const Icon(Icons.stop_circle),
                      onPressed: () => _stopTimer(),
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
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../services/database_helper.dart';
import 'add_task_screen.dart';
import 'assigned_tasks_screen.dart';
import 'my_tasks_screen.dart';
import 'profile_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final Uuid _uuid = const Uuid();
  late DatabaseHelper _databaseHelper;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Color _celebrationButtonColor = Colors.transparent;

  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    _loadTasks();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _triggerCelebration() async {
    _confettiController.play();

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 200);
    }

    try {
      await _audioPlayer.play(AssetSource('sounds/achievement.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
      debugPrint("Please ensure 'assets/sounds/achievement.mp3' exists.");
    }

    setState(() {
      _celebrationButtonColor = Colors.green.withOpacity(0.5);
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _celebrationButtonColor = Colors.transparent;
      });
    });
  }

  Future<void> _loadTasks() async {
    final tasks = await _databaseHelper.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  final User _currentUser = User(
    name: 'Antonio',
    email: 'antonio.antonio@example.com',
    profilePictureUrl: 'https://avatars.githubusercontent.com/u/1?v=4',
    organization: 'Google',
    bio: 'Desarrollador Flutter apasionado por la productividad.',
  );

  int _level = 1;
  int _points = 45; // Example points
  int _pointsForNextLevel = 100;

  void _updateTaskCompletion(int index, bool isCompleted) async {
    final task = _tasks[index].copyWith(isCompleted: isCompleted);
    await _databaseHelper.updateTask(task);
    _loadTasks();
  }

  void _deleteTask(int index) async {
    final task = _tasks[index];
    await _databaseHelper.deleteTask(task.id);
    _loadTasks();
  }

  void _updateTask(Task updatedTask) async {
    await _databaseHelper.updateTask(updatedTask);
    _loadTasks();
  }

  void _navigateToAddTaskScreen() {
    final TaskAssignmentType assignmentType = _selectedIndex == 0
        ? TaskAssignmentType.assigned
        : TaskAssignmentType.mine;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          onAddTask: (newTask) async {
            await _databaseHelper.insertTask(newTask);
            _loadTasks();
          },
          initialAssignmentType: assignmentType,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = _points / _pointsForNextLevel;
    if (progress < 0) progress = 0;
    if (progress > 1) progress = 1;

    final List<Widget> widgetOptions = <Widget>[
      AssignedTasksScreen(
        tasks: _tasks,
        onTaskCompletionChanged: _updateTaskCompletion,
        onTaskDismissed: _deleteTask,
        onTaskUpdated: _updateTask,
      ),
      MyTasksScreen(
        tasks: _tasks,
        onTaskCompletionChanged: _updateTaskCompletion,
        onTaskDismissed: _deleteTask,
        onTaskUpdated: _updateTask,
      ),
      StatsScreen(
        level: _level,
        points: _points,
        pointsForNextLevel: _pointsForNextLevel,
      ),
      ProfileScreen(
        level: _level,
        points: _points,
        pointsForNextLevel: _pointsForNextLevel,
        user: _currentUser,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Tareas'),
        actions: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: _celebrationButtonColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.celebration),
              onPressed: _triggerCelebration,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: Center(
              child: Row(
                children: [
                  Text('Nivel $_level',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100,
                    child: LinearPercentIndicator(
                      percent: progress,
                      lineHeight: 10.0,
                      barRadius: const Radius.circular(5),
                      progressColor: Colors.lightGreenAccent,
                      backgroundColor: Colors.white.withOpacity(0.4),
                      animation: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Center(
            child: widgetOptions.elementAt(_selectedIndex),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Designadas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: 'Mias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Estadísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: _navigateToAddTaskScreen,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

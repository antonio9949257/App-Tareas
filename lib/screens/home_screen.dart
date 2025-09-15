import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package
import '../models/task.dart';
import '../models/user.dart'; // Import the User model
import '../services/database_helper.dart'; // Import the DatabaseHelper
import 'stats_screen.dart';
import 'profile_screen.dart';
import 'add_task_screen.dart';
import 'assigned_tasks_screen.dart'; // Import the new screen
import 'my_tasks_screen.dart'; // Import the new screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final Uuid _uuid = const Uuid(); // Initialize Uuid
  late DatabaseHelper _databaseHelper;

  List<Task> _tasks = []; // Make _tasks mutable

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _loadTasks();
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
    profilePictureUrl: 'https://avatars.githubusercontent.com/u/1?v=4', // Example URL
    organization: 'Google',
    bio: 'Desarrollador Flutter apasionado por la productividad.',
  );

  int _level = 1;
  int _points = 0;
  int _pointsForNextLevel = 100;

  void _updateTaskCompletion(int index, bool isCompleted) async {
    final task = _tasks[index].copyWith(isCompleted: isCompleted);
    await _databaseHelper.updateTask(task);
    _loadTasks(); // Reload tasks to update the UI and points
  }

  

  void _deleteTask(int index) async {
    final task = _tasks[index];
    await _databaseHelper.deleteTask(task.id);
    _loadTasks(); // Reload tasks from the database
  }

  void _updateTask(Task updatedTask) async {
    await _databaseHelper.updateTask(updatedTask);
    _loadTasks(); // Reload tasks from the database
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
            _loadTasks(); // Reload tasks from the database
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
    final List<Widget> widgetOptions = <Widget>[
      AssignedTasksScreen(
        tasks: _tasks,
        onTaskCompletionChanged: _updateTaskCompletion,
        onTaskDismissed: _deleteTask,
        onTaskUpdated: _updateTask,
      ), // New screen
      MyTasksScreen(
        tasks: _tasks,
        onTaskCompletionChanged: _updateTaskCompletion,
        onTaskDismissed: _deleteTask,
        onTaskUpdated: _updateTask,
      ),      // New screen
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
        title: const Text('Lista de Tareas'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Nivel: $_level | Puntos: $_points / $_pointsForNextLevel',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
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

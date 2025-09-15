import 'package:flutter/material.dart';
import '../models/user.dart';

class ProfileScreen extends StatelessWidget {
  final int level;
  final int points;
  final int pointsForNextLevel;
  final User user;

  const ProfileScreen({
    super.key,
    required this.level,
    required this.points,
    required this.pointsForNextLevel,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black,
                ),
                const SizedBox(height: 10),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progreso',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.star),
                    title: const Text('Nivel'),
                    trailing: Text('$level'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.score),
                    title: const Text('Puntos'),
                    trailing: Text('$points / $pointsForNextLevel'),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acerca de',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Divider(),
                  if (user.organization != null)
                    ListTile(
                      leading: const Icon(Icons.business),
                      title: const Text('Organización'),
                      trailing: Text(user.organization!),
                    ),
                  if (user.bio != null)
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('Biografía'),
                      subtitle: Text(user.bio!),
                    ),
                  ListTile(
                    leading: const Icon(Icons.task_alt),
                    title: const Text('Tareas Completadas'),
                    trailing: const Text('(implementar conteo)'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StatsScreen extends StatelessWidget {
  final int level;
  final int points;
  final int pointsForNextLevel;

  const StatsScreen({
    super.key,
    required this.level,
    required this.points,
    required this.pointsForNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    double progress = points / pointsForNextLevel;
    if (progress < 0) progress = 0;
    if (progress > 1) progress = 1;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Tu Progreso',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 15.0,
                percent: progress,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'NIVEL',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    Text(
                      '$level',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.grey[300]!,
                progressColor: Colors.green[600],
                animation: true,
                animationDuration: 1200,
              ),
              const SizedBox(height: 20),
              Text(
                '$points / $pointsForNextLevel Puntos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 30),
              const Text(
                'Insignias de Nivel',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          index < level ? Icons.star : Icons.star_border,
                          color: Colors.amber[400],
                          size: 35,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Card(
                color: Colors.blueGrey[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Flujo Ideal de Trabajo',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '¡Sigue así! Recuerda usar la técnica Pomodoro para mantenerte enfocado y productivo.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

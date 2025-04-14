// screens/workout_list_screen.dart
import 'package:c25k_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:c25k_app/models/workout.dart';
import 'package:c25k_app/services/workout_service.dart';
import 'package:c25k_app/screens/workout_screen.dart';

class WorkoutListScreen extends StatelessWidget {
  final int weekNumber;

  const WorkoutListScreen({Key? key, required this.weekNumber})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WorkoutService workoutService = WorkoutService();

    return Scaffold(
      appBar: CustomAppBar(title: 'Week $weekNumber Workouts'),
      body: FutureBuilder<List<Workout>>(
        future: workoutService.getWorkoutsByWeek(weekNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading workouts: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No workouts found for this week'));
          }

          final workouts = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];

              return Card(
                elevation: 4.0,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutScreen(workout: workout),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          workout.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Total time: ${_formatDuration(workout.totalDurationSeconds)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

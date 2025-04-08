// screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/workout_service.dart';
import 'workout_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WorkoutService workoutService = WorkoutService();

    return Scaffold(
      appBar: AppBar(title: const Text('C25K Runner')),
      body: FutureBuilder<List<Workout>>(
        future: workoutService.loadWorkouts(),
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
            return const Center(child: Text('No workouts found'));
          }

          // Get unique week numbers
          final List<int> weekNumbers =
              snapshot.data!
                  .map((workout) => workout.weekNumber)
                  .toSet()
                  .toList()
                ..sort();

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: weekNumbers.length,
            itemBuilder: (context, index) {
              final weekNumber = weekNumbers[index];

              return Card(
                elevation: 4.0,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                WorkoutListScreen(weekNumber: weekNumber),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Week $weekNumber',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Tap to see this week\'s workouts',
                          style: Theme.of(context).textTheme.bodyMedium,
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
}

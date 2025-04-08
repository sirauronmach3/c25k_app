// services/workout_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/workout.dart';

class WorkoutService {
  Future<List<Workout>> loadWorkouts() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/workouts.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    List<Workout> allWorkouts = [];

    for (var week in jsonData['weeks']) {
      int weekNumber = week['weekNumber'];

      for (var workoutJson in week['workouts']) {
        Workout workout = Workout.fromJson(workoutJson, weekNumber);
        allWorkouts.add(workout);
      }
    }

    return allWorkouts;
  }

  Future<List<Workout>> getWorkoutsByWeek(int weekNumber) async {
    final allWorkouts = await loadWorkouts();
    return allWorkouts
        .where((workout) => workout.weekNumber == weekNumber)
        .toList();
  }
}

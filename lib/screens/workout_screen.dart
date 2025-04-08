// screens/workout_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:c25k_app/models/workout.dart';
import 'package:c25k_app/models/interval.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutScreen({Key? key, required this.workout}) : super(key: key);

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late List<Interval> intervals;
  late int currentIntervalIndex;
  late int remainingSeconds;
  late Timer? timer;
  bool isWorkoutActive = false;
  bool isWorkoutCompleted = false;

  @override
  void initState() {
    super.initState();
    intervals = widget.workout.intervals;
    currentIntervalIndex = 0;
    remainingSeconds = intervals[currentIntervalIndex].totalSeconds;
    timer = null;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startWorkout() {
    setState(() {
      isWorkoutActive = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          // Move to next interval
          if (currentIntervalIndex < intervals.length - 1) {
            currentIntervalIndex++;
            remainingSeconds = intervals[currentIntervalIndex].totalSeconds;
          } else {
            // Workout complete
            timer.cancel();
            isWorkoutActive = false;
            isWorkoutCompleted = true;
          }
        }
      });
    });
  }

  void pauseWorkout() {
    timer?.cancel();
    setState(() {
      isWorkoutActive = false;
    });
  }

  void resetWorkout() {
    timer?.cancel();
    setState(() {
      currentIntervalIndex = 0;
      remainingSeconds = intervals[currentIntervalIndex].totalSeconds;
      isWorkoutActive = false;
      isWorkoutCompleted = false;
    });
  }

  Color _getColorForActivityType(String activityType) {
    switch (activityType) {
      case 'warmup':
        return Colors.yellow;
      case 'run':
        return Colors.green;
      case 'walk':
        return Colors.blue;
      case 'cooldown':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _getActivityLabel(String activityType) {
    switch (activityType) {
      case 'warmup':
        return 'Warm Up';
      case 'run':
        return 'Run';
      case 'walk':
        return 'Walk';
      case 'cooldown':
        return 'Cool Down';
      default:
        return activityType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentInterval = intervals[currentIntervalIndex];
    final activityColor = _getColorForActivityType(
      currentInterval.activityType,
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.workout.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isWorkoutCompleted) ...[
              const Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                'Workout Complete!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: resetWorkout,
                child: const Text('Start Over'),
              ),
            ] else ...[
              Text(
                _getActivityLabel(currentInterval.activityType),
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: activityColor),
              ),
              const SizedBox(height: 16),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activityColor.withOpacity(0.2),
                  border: Border.all(color: activityColor, width: 8),
                ),
                child: Center(
                  child: Text(
                    _formatDuration(remainingSeconds),
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Interval ${currentIntervalIndex + 1} of ${intervals.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isWorkoutActive)
                    ElevatedButton.icon(
                      onPressed: startWorkout,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(
                        currentIntervalIndex == 0 &&
                                remainingSeconds == intervals[0].totalSeconds
                            ? 'Start Workout'
                            : 'Resume',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: pauseWorkout,
                      icon: const Icon(Icons.pause),
                      label: const Text('Pause'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: resetWorkout,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

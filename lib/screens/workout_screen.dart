import 'dart:async';
import 'package:c25k_app/services/notification_service.dart';
import 'package:c25k_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:c25k_app/models/workout.dart';
import 'package:c25k_app/models/interval.dart' as interval_model;

class WorkoutScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutScreen({super.key, required this.workout});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late List<interval_model.Interval> intervals;
  late int currentIntervalIndex;
  late int remainingSeconds;
  late Timer? timer;
  bool isWorkoutActive = false;
  bool isWorkoutCompleted = false;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    intervals = widget.workout.intervals;
    currentIntervalIndex = 0;
    remainingSeconds = intervals[currentIntervalIndex].totalSeconds;
    timer = null; // Don't initialize timer automatically
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

    // Initialize timer when starting workout
    timer = _initiateTimer();

    // Announce first activity when starting workout
    if (currentIntervalIndex == 0 &&
        remainingSeconds == intervals[0].totalSeconds) {
      _notificationService.notifyActivityChange(intervals[0].activityType);
    }
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

  void skipToNextInterval() {
    if (currentIntervalIndex < intervals.length - 1) {
      setState(() {
        currentIntervalIndex++;
        remainingSeconds = intervals[currentIntervalIndex].totalSeconds;
        _notificationService.notifyActivityChange(
          intervals[currentIntervalIndex].activityType,
        );
      });
    }
  }

  void endWorkout() {
    timer?.cancel();
    setState(() {
      isWorkoutActive = false;
      isWorkoutCompleted = true;
    });
    _notificationService.notifyWorkoutComplete();
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
      appBar: CustomAppBar(title: widget.workout.title),
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
                        style: TextStyle(color: Colors.black),
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
                      label: const Text(
                        'Pause',
                        style: TextStyle(color: Colors.black),
                      ),
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
                    label: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.black),
                    ),
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed:
                        currentIntervalIndex < intervals.length - 1
                            ? skipToNextInterval
                            : null,
                    icon: const Icon(Icons.skip_next),
                    label: const Text(
                      'Skip Interval',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: endWorkout,
                    icon: const Icon(Icons.stop),
                    label: const Text(
                      'End Workout',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
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

  Timer? _initiateTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;

          // Optional: Add countdown notifications
          if (remainingSeconds == 3) {
            _notificationService.notifyCountdown(3);
          }
        } else {
          // Move to next interval
          if (currentIntervalIndex < intervals.length - 1) {
            currentIntervalIndex++;
            final newInterval = intervals[currentIntervalIndex];
            remainingSeconds = newInterval.totalSeconds;

            // Notify user of specific activity change
            _notificationService.notifyActivityChange(newInterval.activityType);
          } else {
            // Workout complete
            timer.cancel();
            isWorkoutActive = false;
            isWorkoutCompleted = true;

            // Notify user that workout is complete
            _notificationService.notifyWorkoutComplete();
          }
        }
      });
    });
    return timer;
  }
}

import 'package:c25k_app/services/interval_service.dart';
import 'package:c25k_app/widgets/custom_app_bar.dart';
import 'package:c25k_app/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:c25k_app/models/workout.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter_background/flutter_background.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutScreen({super.key, required this.workout});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late final IntervalService _service;
  bool backgroundExecutionEnabled = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _service = IntervalService(intervals: widget.workout.intervals);
    _service.addListener(() => setState(() {}));
    _enableBackgroundExecution();
  }

  Future<bool> _enableBackgroundExecution() async {
    backgroundExecutionEnabled =
        await FlutterBackground.enableBackgroundExecution();
    return backgroundExecutionEnabled;
  }

  Future<bool> _disableBackgroundExecution() async {
    if (backgroundExecutionEnabled) {
      return await FlutterBackground.disableBackgroundExecution();
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    _service.dispose();
    WakelockPlus.disable();
    _disableBackgroundExecution();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final currentInterval = _service.currentInterval;
    final activityColor = currentInterval.getColorForActivityType();

    return Scaffold(
      appBar: CustomAppBar(title: widget.workout.title),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_service.isCompleted) ...[
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
                onPressed: _service.reset,
                child: const Text('Start Over'),
              ),
            ] else ...[
              Text(
                currentInterval.getActivityLabel(),
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
                    _formatDuration(_service.remainingSeconds),
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Interval ${_service.currentIntervalIndex + 1} of ${_service.intervals.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WorkoutPlayPauseButton(
                    isActive: _service.isActive,
                    isAtStart:
                        _service.currentIntervalIndex == 0 &&
                        _service.remainingSeconds ==
                            _service.intervals[0].totalSeconds,
                    onStart: _service.start,
                    onPause: _service.pause,
                  ),
                  const SizedBox(width: 16),
                  WorkoutResetButton(onPressed: _service.reset),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WorkoutSkipButton(
                    onPressed:
                        _service.currentIntervalIndex <
                                _service.intervals.length - 1
                            ? _service.skip
                            : null,
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _service.end,
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
}

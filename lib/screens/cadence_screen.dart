import 'dart:async';

import 'package:c25k_app/models/interval.dart' as app;
import 'package:c25k_app/services/notification_service.dart';
import 'package:c25k_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

/// Screen for setting a cadence of run and walk intervals.
/// Allows selecting the run and walk intervals seperately, and also optionally the total duration of the workout.
/// The values are set at the bottom of the screen, and a start button is provided to start the workout with the selected values.
///
/// The cadence is displayed in the top half of the screen, with the current activity type and remaining time for that activity.

class CadenceScreen extends StatefulWidget {
  const CadenceScreen({Key? key}) : super(key: key);

  @override
  _CadenceScreenState createState() => _CadenceScreenState();
}

class _CadenceScreenState extends State<CadenceScreen> {
  late List<app.Interval> intervals;
  late app.Interval currentInterval;
  bool isRunning = false;
  late Timer? timer;
  final NotificationService _notificationService = NotificationService();
  late int remainingSeconds;
  int currentIntervalIndex = 0;

  @override
  void initState() {
    intervals = [
      app.Interval(activityType: 'run', durationMinutes: 1, durationSeconds: 0),
      app.Interval(
        activityType: 'walk',
        durationMinutes: 0,
        durationSeconds: 30,
      ),
    ];
    currentInterval = intervals[0];
    timer = null;
    setRemainingSeconds();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void setRemainingSeconds() {
    if (!isRunning) {
      remainingSeconds = intervals[0].totalSeconds;
    } else {
      currentIntervalIndex = (currentIntervalIndex + 1) % intervals.length;
      currentInterval = intervals[currentIntervalIndex];
      remainingSeconds = currentInterval.totalSeconds;
    }
  }

  void _startTimer() {
    if (timer?.isActive ?? false) return;
    setState(() => isRunning = true);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          _nextInterval();
        }
      });
    });
  }

  void _pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void _toggleTimer() {
    if (isRunning) {
      _pauseTimer();
    } else {
      _startTimer();
    }
  }

  void _nextInterval() {
    currentIntervalIndex = (currentIntervalIndex + 1) % intervals.length;
    currentInterval = intervals[currentIntervalIndex];
    remainingSeconds = currentInterval.totalSeconds;
  }

  void _skipInterval() {
    setState(() => _nextInterval());
  }

  void _stopWorkout() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      currentIntervalIndex = 0;
      currentInterval = intervals[0];
      remainingSeconds = currentInterval.totalSeconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Cadence Setter"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentInterval.getActivityLabel(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: currentInterval.getColorForActivityType(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentInterval
                          .getColorForActivityType()
                          .withOpacity(0.5),
                      border: Border.all(
                        color: currentInterval.getColorForActivityType(),
                        width: 8,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$remainingSeconds s',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Run duration: ${intervals[0].formatDuration()}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 16),
                      Text(
                        "Walk duration: ${intervals[1].formatDuration()}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text("Run time (seconds)"),
                          SizedBox(height: 8),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: intervals[0].totalSeconds.toString(),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  intervals[0] = app.Interval(
                                    activityType: intervals[0].activityType,
                                    durationMinutes: 0,
                                    durationSeconds: int.tryParse(value) ?? 0,
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 40),
                      Column(
                        children: [
                          Text("Walk time (seconds)"),
                          SizedBox(height: 8),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: intervals[1].totalSeconds.toString(),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  intervals[1] = app.Interval(
                                    activityType: intervals[1].activityType,
                                    durationMinutes: 0,
                                    durationSeconds: int.tryParse(value) ?? 0,
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _toggleTimer,
                      child: Text(
                        isRunning ? "Pause" : "Start",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isRunning ? Colors.orange : Colors.green,
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _skipInterval,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        "Skip",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _stopWorkout,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text(
                    "Stop Workout",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

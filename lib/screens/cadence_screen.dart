import 'package:c25k_app/models/interval.dart' as app;
import 'package:c25k_app/services/interval_service.dart';
import 'package:c25k_app/widgets/custom_app_bar.dart';
import 'package:c25k_app/widgets/custom_buttons.dart';
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
  late final IntervalService _service;

  @override
  void initState() {
    super.initState();
    _service = IntervalService(
      intervals: [
        app.Interval(
          activityType: 'run',
          durationMinutes: 1,
          durationSeconds: 0,
        ),
        app.Interval(
          activityType: 'walk',
          durationMinutes: 0,
          durationSeconds: 30,
        ),
      ],
      cyclic: true,
    );
    _service.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intervals = _service.intervals;
    final currentInterval = _service.currentInterval;

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
                        '${_service.remainingSeconds} s',
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
                                _service.updateInterval(
                                  0,
                                  app.Interval(
                                    activityType: intervals[0].activityType,
                                    durationMinutes: 0,
                                    durationSeconds: int.tryParse(value) ?? 0,
                                  ),
                                );
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
                                _service.updateInterval(
                                  1,
                                  app.Interval(
                                    activityType: intervals[1].activityType,
                                    durationMinutes: 0,
                                    durationSeconds: int.tryParse(value) ?? 0,
                                  ),
                                );
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
                    WorkoutPlayPauseButton(
                      isActive: _service.isActive,
                      isAtStart:
                          _service.currentIntervalIndex == 0 &&
                          _service.remainingSeconds ==
                              _service.intervals[0].totalSeconds,
                      onStart: _service.start,
                      onPause: _service.pause,
                    ),
                    SizedBox(width: 20),
                    WorkoutSkipButton(onPressed: _service.skip),
                  ],
                ),
                SizedBox(height: 20),
                WorkoutResetButton(onPressed: _service.reset),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

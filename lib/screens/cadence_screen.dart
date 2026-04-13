import 'dart:async';

import 'package:c25k_app/services/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Screen for setting a cadence of run and walk intervals.
/// Allows selecting the run and walk intervals seperately, and also optionally the total duration of the workout.
/// The values are set at the bottom of the screen, and a start button is provided to start the workout with the selected values.
///
/// The cadence is displayed in the top half of the screen, the color of the screen changes based on the current interval (run, walk, or waiting)
/// Waiting : default background color
/// Run : Red background color
/// Walk : Green background color
///

class CadenceScreen extends StatefulWidget {
  const CadenceScreen({Key? key}) : super(key: key);

  @override
  _CadenceScreenState createState() => _CadenceScreenState();
}

class _CadenceScreenState extends State<CadenceScreen> {
  int runInterval = 60; // default run interval in seconds
  int walkInterval = 30; // default walk interval in seconds
  bool isRunning = false;
  late Timer? timer;
  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadence Selector')),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Text("Run time $runInterval seconds"),
                SizedBox(width: 20),
                Text("Walk time $walkInterval seconds"),
              ],
            ),
            SizedBox(height: 20),
            Row(children: [Text("Placeholder for cadence display")]),
            SizedBox(height: 20),
            Row(children: [Text("Placeholder for cadence selection")]),
            Row(
              children: [
                Text("Run time selection"),
                SizedBox(width: 20),
                Text("Walk time selection"),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text("Start Workout")),
          ],
        ),
      ),
    );
  }
}

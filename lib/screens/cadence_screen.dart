import 'package:flutter/cupertino.dart';

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
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

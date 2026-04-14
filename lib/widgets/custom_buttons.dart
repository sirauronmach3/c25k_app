import 'package:flutter/material.dart';

/// Start/Resume or Pause button depending on [isActive].
/// When inactive, shows "Start Workout" if [isAtStart], otherwise "Resume".
class WorkoutPlayPauseButton extends StatelessWidget {
  final bool isActive;
  final bool isAtStart;
  final VoidCallback onStart;
  final VoidCallback onPause;

  const WorkoutPlayPauseButton({
    super.key,
    required this.isActive,
    required this.isAtStart,
    required this.onStart,
    required this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive) {
      return ElevatedButton.icon(
        onPressed: onStart,
        icon: const Icon(Icons.play_arrow),
        label: Text(
          isAtStart ? 'Start Workout' : 'Resume',
          style: const TextStyle(color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: onPause,
        icon: const Icon(Icons.pause),
        label: const Text('Pause', style: TextStyle(color: Colors.black)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );
    }
  }
}

/// Skip to the next interval. Pass null to [onPressed] to disable.
class WorkoutSkipButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const WorkoutSkipButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.skip_next),
      label: const Text('Skip Interval', style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    );
  }
}

/// Reset the workout back to the beginning.
class WorkoutResetButton extends StatelessWidget {
  final VoidCallback onPressed;

  const WorkoutResetButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh),
      label: const Text('Reset', style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}

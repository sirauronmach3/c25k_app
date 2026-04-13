import 'dart:ui';

import 'package:flutter/material.dart';

class Interval {
  final String activityType; // "walk", "run", "warmup", "cooldown"
  final int durationMinutes;
  final int durationSeconds;

  const Interval({
    required this.activityType,
    this.durationMinutes = 0,
    this.durationSeconds = 0,
  });

  int get totalSeconds => (durationMinutes * 60) + durationSeconds;

  factory Interval.fromJson(Map<String, dynamic> json) {
    return Interval(
      activityType: json['activityType'],
      durationMinutes: json['durationMinutes'] ?? 0,
      durationSeconds: json['durationSeconds'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activityType': activityType,
      'durationMinutes': durationMinutes,
      'durationSeconds': durationSeconds,
    };
  }

  Color getColorForActivityType() {
    switch (this.activityType) {
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

  String getActivityLabel() {
    switch (this.activityType) {
      case 'warmup':
        return 'Warm Up';
      case 'run':
        return 'Run';
      case 'walk':
        return 'Walk';
      case 'cooldown':
        return 'Cool Down';
      default:
        return this.activityType;
    }
  }

  String formatDuration() {
    return '$durationMinutes:${durationSeconds.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return '${getActivityLabel()}, ${formatDuration()}';
  }
}

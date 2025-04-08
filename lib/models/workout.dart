import 'package:c25k_app/models/interval.dart';

class Workout {
  final String title;
  final String description;
  final List<Interval> intervals;
  final int weekNumber;
  final int dayNumber;

  const Workout({
    required this.title,
    required this.description,
    required this.intervals,
    required this.weekNumber,
    required this.dayNumber,
  });

  int get totalDurationSeconds =>
      intervals.fold(0, (sum, interval) => sum + interval.totalSeconds);

  factory Workout.fromJson(Map<String, dynamic> json, int weekNum) {
    return Workout(
      title: json['title'],
      description: json['description'],
      weekNumber: weekNum,
      dayNumber: json['dayNumber'],
      intervals:
          (json['intervals'] as List)
              .map((interval) => Interval.fromJson(interval))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dayNumber': dayNumber,
      'intervals': intervals.map((interval) => interval.toJson()).toList(),
    };
  }
}

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
}

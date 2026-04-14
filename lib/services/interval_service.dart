import 'dart:async';

import 'package:c25k_app/models/interval.dart' as app;
import 'package:c25k_app/services/notification_service.dart';
import 'package:flutter/foundation.dart';

/// Manages the shared state and logic for interval-based workout timers.
/// Consumed by both [WorkoutScreen] and [CadenceScreen].
///
/// Set [cyclic] to true for screens that loop intervals indefinitely
/// (CadenceScreen). Leave false for screens that end after the last interval
/// (WorkoutScreen).
class IntervalService extends ChangeNotifier {
  List<app.Interval> _intervals;
  int _currentIntervalIndex = 0;
  late int _remainingSeconds;
  Timer? _timer;
  bool _isActive = false;
  bool _isCompleted = false;
  final bool cyclic;
  final NotificationService _notificationService;

  IntervalService({
    required List<app.Interval> intervals,
    this.cyclic = false,
    NotificationService? notificationService,
  })  : _intervals = List.of(intervals),
        _notificationService = notificationService ?? NotificationService() {
    _remainingSeconds = _intervals[0].totalSeconds;
  }

  List<app.Interval> get intervals => List.unmodifiable(_intervals);
  int get currentIntervalIndex => _currentIntervalIndex;
  int get remainingSeconds => _remainingSeconds;
  bool get isActive => _isActive;
  bool get isCompleted => _isCompleted;
  app.Interval get currentInterval => _intervals[_currentIntervalIndex];

  void start() {
    if (_timer?.isActive ?? false) return;
    _isActive = true;
    if (_currentIntervalIndex == 0 &&
        _remainingSeconds == _intervals[0].totalSeconds) {
      _notificationService.notifyActivityChange(_intervals[0].activityType);
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        if (_remainingSeconds == 3) {
          _notificationService.notifyCountdown(3);
        }
      } else {
        _advance();
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void pause() {
    _timer?.cancel();
    _isActive = false;
    notifyListeners();
  }

  void skip() {
    if (cyclic || _currentIntervalIndex < _intervals.length - 1) {
      _currentIntervalIndex =
          (_currentIntervalIndex + 1) % _intervals.length;
      _remainingSeconds = _intervals[_currentIntervalIndex].totalSeconds;
      _notificationService
          .notifyActivityChange(_intervals[_currentIntervalIndex].activityType);
      notifyListeners();
    }
  }

  void reset() {
    _timer?.cancel();
    _currentIntervalIndex = 0;
    _remainingSeconds = _intervals[0].totalSeconds;
    _isActive = false;
    _isCompleted = false;
    notifyListeners();
  }

  void end() {
    _timer?.cancel();
    _isActive = false;
    _isCompleted = true;
    _notificationService.notifyWorkoutComplete();
    notifyListeners();
  }

  void updateInterval(int index, app.Interval interval) {
    assert(index >= 0 && index < _intervals.length);
    _intervals[index] = interval;
    notifyListeners();
  }

  void _advance() {
    if (cyclic) {
      _currentIntervalIndex =
          (_currentIntervalIndex + 1) % _intervals.length;
      _remainingSeconds = _intervals[_currentIntervalIndex].totalSeconds;
      _notificationService
          .notifyActivityChange(_intervals[_currentIntervalIndex].activityType);
    } else if (_currentIntervalIndex < _intervals.length - 1) {
      _currentIntervalIndex++;
      _remainingSeconds = _intervals[_currentIntervalIndex].totalSeconds;
      _notificationService
          .notifyActivityChange(_intervals[_currentIntervalIndex].activityType);
    } else {
      _timer?.cancel();
      _isActive = false;
      _isCompleted = true;
      _notificationService.notifyWorkoutComplete();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

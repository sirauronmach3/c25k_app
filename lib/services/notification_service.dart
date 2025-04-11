import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FlutterTts _flutterTts = FlutterTts();

  NotificationService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(
      0.5,
    ); // Slightly slower for clearer instructions
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<bool> _isAudioEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('audioEnabled') ?? true;
  }

  Future<bool> _isVibrationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('vibrationEnabled') ?? true;
  }

  Future<void> speak(String text) async {
    if (await _isAudioEnabled()) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> vibrate() async {
    if (await _isVibrationEnabled()) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 500);
      }
    }
  }

  // Notify of interval change with appropriate message
  Future<void> notifyActivityChange(String activityType) async {
    String message;

    switch (activityType) {
      case 'run':
        message = "Start running now";
        break;
      case 'walk':
        message = "Start walking now";
        break;
      case 'warmup':
        message = "Begin warm up";
        break;
      case 'cooldown':
        message = "Begin cool down";
        break;
      default:
        message = "Change activity";
    }

    await speak(message);
    await vibrate();
  }

  Future<void> notifyWorkoutComplete() async {
    await speak("Workout complete! Great job!");
    await vibrate();
  }

  // Could add countdown notifications
  Future<void> notifyCountdown(int seconds) async {
    await speak("$seconds seconds remaining");
  }
}

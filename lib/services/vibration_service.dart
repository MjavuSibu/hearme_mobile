import 'package:vibration/vibration.dart';

class VibrationService {
  VibrationService._();

  static const Map<String, List<int>> _patterns = {
    'Emergency Siren': [0, 120, 60, 120, 60, 120],
    'Fire Alarm':       [0, 200, 100, 200, 100],
    'Dog Barking':      [0, 150, 80, 150],
    'Car Horn':         [0, 300, 100, 300],
  };

  static const List<int> _defaultPattern = [0, 200, 100, 200];

  static Future<void> vibrate(String sound) async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (!hasVibrator) return;

    final pattern = _patterns[sound] ?? _defaultPattern;
    Vibration.vibrate(pattern: pattern);
  }

  static Future<void> cancel() async {
    Vibration.cancel();
  }
}
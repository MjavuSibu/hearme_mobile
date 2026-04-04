import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/sound_alert.dart';
import '../models/app_settings.dart';
import 'vibration_service.dart';
import 'notification_service.dart';

class AlertManager extends ChangeNotifier {
  AlertManager({required AppSettings settings}) : _settings = settings;

  AppSettings _settings;

  final List<SoundAlert> _history = [];
  SoundAlert? _latest;
  bool _flashActive = false;
  StreamSubscription? _subscription;

  List<SoundAlert> get history => List.unmodifiable(_history);
  SoundAlert? get latest => _latest;
  bool get flashActive => _flashActive;

  void updateSettings(AppSettings settings) {
    _settings = settings;
  }

  void listenTo(Stream<SoundAlert> stream) {
    _subscription?.cancel();
    _subscription = stream.listen(_handleAlert);
  }

  Future<void> _handleAlert(SoundAlert alert) async {
    if (alert.confidence < _settings.confidenceThreshold) return;

    _latest = alert;
    _history.insert(0, alert);
    if (_history.length > 100) _history.removeLast();

    notifyListeners();

    if (_settings.vibrateOnAlert) {
      await VibrationService.vibrate(alert.sound);
    }

    if (_settings.notifyOnAlert) {
      await NotificationService.showAlert(alert.sound, alert.confidence);
    }

    if (_settings.flashOnAlert) {
      _triggerFlash();
    }
  }

  void _triggerFlash() {
    _flashActive = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 600), () {
      _flashActive = false;
      notifyListeners();
    });
  }

  void clearHistory() {
    _history.clear();
    _latest = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
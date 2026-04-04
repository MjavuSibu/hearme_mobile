import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  AppSettings({
    required this.serverIp,
    required this.serverPort,
    required this.vibrateOnAlert,
    required this.flashOnAlert,
    required this.notifyOnAlert,
    required this.confidenceThreshold,
  });

  String serverIp;
  int serverPort;
  bool vibrateOnAlert;
  bool flashOnAlert;
  bool notifyOnAlert;
  double confidenceThreshold;

  static const String _keyIp = 'server_ip';
  static const String _keyPort = 'server_port';
  static const String _keyVibrate = 'vibrate';
  static const String _keyFlash = 'flash';
  static const String _keyNotify = 'notify';
  static const String _keyThreshold = 'threshold';

  static AppSettings defaults() {
    return AppSettings(
      serverIp: '192.168.1.100',
      serverPort: 8765,
      vibrateOnAlert: true,
      flashOnAlert: true,
      notifyOnAlert: true,
      confidenceThreshold: 0.4,
    );
  }

  static Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      serverIp: prefs.getString(_keyIp) ?? '192.168.1.100',
      serverPort: prefs.getInt(_keyPort) ?? 8765,
      vibrateOnAlert: prefs.getBool(_keyVibrate) ?? true,
      flashOnAlert: prefs.getBool(_keyFlash) ?? true,
      notifyOnAlert: prefs.getBool(_keyNotify) ?? true,
      confidenceThreshold: prefs.getDouble(_keyThreshold) ?? 0.4,
    );
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyIp, serverIp);
    await prefs.setInt(_keyPort, serverPort);
    await prefs.setBool(_keyVibrate, vibrateOnAlert);
    await prefs.setBool(_keyFlash, flashOnAlert);
    await prefs.setBool(_keyNotify, notifyOnAlert);
    await prefs.setDouble(_keyThreshold, confidenceThreshold);
  }

  String get wsUrl => 'ws://$serverIp:$serverPort';
}
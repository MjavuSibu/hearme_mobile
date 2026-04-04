import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../theme/app_theme.dart';

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  static Future<void> showAlert(String sound, double confidence) async {
    final theme = SoundTheme.of(sound);
    final pct = (confidence * 100).toStringAsFixed(0);

    final androidDetails = AndroidNotificationDetails(
      'hearme_alerts',
      'Sound Alerts',
      channelDescription: 'Danger sound detection notifications',
      importance: Importance.high,
      priority: Priority.high,
      color: theme.fg,
      enableVibration: false,
      playSound: false,
      ticker: sound,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );

    await _plugin.show(
      sound.hashCode,
      '${theme.label}  ·  $pct% match',
      sound,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }
}
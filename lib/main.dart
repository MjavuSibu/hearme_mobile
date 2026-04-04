import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/app_settings.dart';
import 'services/alert_manager.dart';
import 'services/connection_service.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await NotificationService.initialize();

  final settings = await AppSettings.load();

  runApp(HearMeApp(settings: settings));
}

class HearMeApp extends StatefulWidget {
  const HearMeApp({required this.settings, super.key});

  final AppSettings settings;

  @override
  State<HearMeApp> createState() => _HearMeAppState();
}

class _HearMeAppState extends State<HearMeApp> {
  late final ConnectionService _connection;
  late final AlertManager _alertManager;

  @override
  void initState() {
    super.initState();
    _connection = ConnectionService();
    _alertManager = AlertManager(settings: widget.settings)
      ..listenTo(_connection.alertStream);

    _connection.connect(widget.settings.wsUrl);
  }

  @override
  void dispose() {
    _connection.dispose();
    _alertManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppSettings>.value(value: widget.settings),
        ChangeNotifierProvider<ConnectionService>.value(value: _connection),
        ChangeNotifierProvider<AlertManager>.value(value: _alertManager),
      ],
      child: MaterialApp(
        title: 'HearMe',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const HomeScreen(),
      ),
    );
  }
}
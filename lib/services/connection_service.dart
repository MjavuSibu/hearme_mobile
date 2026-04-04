import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

import '../models/sound_alert.dart';

enum ConnectionState { disconnected, connecting, connected, error }

class ConnectionService extends ChangeNotifier {
  ConnectionService();

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;

  ConnectionState _state = ConnectionState.disconnected;
  String? _lastError;
  String _wsUrl = '';

  final _alertController = StreamController<SoundAlert>.broadcast();

  ConnectionState get state => _state;
  String? get lastError => _lastError;
  Stream<SoundAlert> get alertStream => _alertController.stream;
  bool get isConnected => _state == ConnectionState.connected;

  Future<void> connect(String wsUrl) async {
    _wsUrl = wsUrl;
    _reconnectTimer?.cancel();
    await _disconnect(notify: false);
    _setState(ConnectionState.connecting);

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      await _channel!.ready;
      _setState(ConnectionState.connected);
      _lastError = null;

      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
      );
    } catch (e) {
      _lastError = e.toString();
      _setState(ConnectionState.error);
      _scheduleReconnect();
    }
  }

  void _onMessage(dynamic raw) {
    try {
      final data = json.decode(raw as String) as Map<String, dynamic>;
      final alert = SoundAlert.fromJson(data);
      _alertController.add(alert);
    } catch (_) {}
  }

  void _onError(Object error) {
    _lastError = error.toString();
    _setState(ConnectionState.error);
    _scheduleReconnect();
  }

  void _onDone() {
    if (_state == ConnectionState.connected) {
      _setState(ConnectionState.disconnected);
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 4), () {
      if (_state != ConnectionState.connected && _wsUrl.isNotEmpty) {
        connect(_wsUrl);
      }
    });
  }

  Future<void> _disconnect({bool notify = true}) async {
    _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close(ws_status.goingAway);
    _channel = null;
    if (notify) {
      _setState(ConnectionState.disconnected);
    }
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _wsUrl = '';
    await _disconnect();
  }

  void _setState(ConnectionState next) {
    _state = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    _alertController.close();
    super.dispose();
  }
}
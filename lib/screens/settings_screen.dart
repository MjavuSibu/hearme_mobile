import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_settings.dart';
import '../services/alert_manager.dart';
import '../services/connection_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppSettings _settings;
  late TextEditingController _ipController;
  late TextEditingController _portController;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _settings = context.read<AppSettings>();
    _ipController = TextEditingController(text: _settings.serverIp);
    _portController = TextEditingController(text: '${_settings.serverPort}');
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  Future<void> _applyAndConnect() async {
    _settings.serverIp = _ipController.text.trim();
    _settings.serverPort = int.tryParse(_portController.text.trim()) ?? 8765;
    await _settings.save();

    if (!mounted) return;
    final connection = context.read<ConnectionService>();
    final manager = context.read<AlertManager>();

    await connection.connect(_settings.wsUrl);
    manager.updateSettings(_settings);

    setState(() => _dirty = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved — reconnecting…'),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  void _markDirty() => setState(() => _dirty = true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,
      appBar: AppBar(
        title: const Text('Settings'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader('Connection'),
            _Card(
              children: [
                _TextRow(
                  label: 'Python server IP',
                  hint: '192.168.1.100',
                  controller: _ipController,
                  keyboard: TextInputType.number,
                  onChanged: (_) => _markDirty(),
                ),
                const _Divider(),
                _TextRow(
                  label: 'Port',
                  hint: '8765',
                  controller: _portController,
                  keyboard: TextInputType.number,
                  onChanged: (_) => _markDirty(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Open a terminal on your PC and run: ipconfig (Windows) or ifconfig (Mac/Linux) to find your local IP address.',
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.5),
              ),
            ),
            const SizedBox(height: 28),
            _SectionHeader('Alerts'),
            _Card(
              children: [
                _ToggleRow(
                  label: 'Vibrate on alert',
                  icon: Icons.vibration,
                  value: _settings.vibrateOnAlert,
                  onChanged: (v) {
                    setState(() => _settings.vibrateOnAlert = v);
                    _markDirty();
                  },
                ),
                const _Divider(),
                _ToggleRow(
                  label: 'Flash screen on alert',
                  icon: Icons.flash_on_rounded,
                  value: _settings.flashOnAlert,
                  onChanged: (v) {
                    setState(() => _settings.flashOnAlert = v);
                    _markDirty();
                  },
                ),
                const _Divider(),
                _ToggleRow(
                  label: 'Push notifications',
                  icon: Icons.notifications_rounded,
                  value: _settings.notifyOnAlert,
                  onChanged: (v) {
                    setState(() => _settings.notifyOnAlert = v);
                    _markDirty();
                  },
                ),
              ],
            ),
            const SizedBox(height: 28),
            _SectionHeader('Detection'),
            _Card(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Confidence threshold',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${(_settings.confidenceThreshold * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Alerts only fire above this confidence level.',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 10),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.accent,
                          inactiveTrackColor: AppColors.surface,
                          thumbColor: AppColors.accent,
                          overlayColor: AppColors.accentLight,
                        ),
                        child: Slider(
                          value: _settings.confidenceThreshold,
                          min: 0.1,
                          max: 0.9,
                          divisions: 16,
                          onChanged: (v) {
                            setState(() => _settings.confidenceThreshold = v);
                            _markDirty();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _dirty ? _applyAndConnect : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.surface,
                    disabledForegroundColor: AppColors.textMuted,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save & Reconnect',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(children: children),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }
}

class _TextRow extends StatelessWidget {
  const _TextRow({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboard = TextInputType.text,
    this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboard;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controller,
              keyboardType: keyboard,
              textAlign: TextAlign.right,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.accent,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: AppColors.textMuted),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accent,
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.accentLight;
              }
              return AppColors.surface;
            }),
          ),
        ],
      ),
    );
  }
}
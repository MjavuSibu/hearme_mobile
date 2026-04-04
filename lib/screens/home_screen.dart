import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/alert_manager.dart';
import '../services/connection_service.dart';
import '../theme/app_theme.dart';
import '../widgets/alert_card.dart';
import '../widgets/alert_history_list.dart';
import '../widgets/connection_status_pill.dart';
import '../widgets/flash_overlay.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<AlertManager>();
    final connection = context.watch<ConnectionService>();

    return FlashOverlay(
      active: manager.flashActive,
      soundName: manager.latest?.sound,
      child: Scaffold(
        backgroundColor: AppColors.page,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: Row(
            children: [
              const Text('HearMe'),
              const SizedBox(width: 10),
              ConnectionStatusPill(state: connection.state),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune_rounded),
              tooltip: 'Settings',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
            const SizedBox(width: 4),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {},
          color: AppColors.accent,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _HeroSection(manager: manager),
                const SizedBox(height: 28),
                AlertHistoryList(
                  alerts: manager.history,
                  onClear: manager.clearHistory,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.manager});

  final AlertManager manager;

  @override
  Widget build(BuildContext context) {
    final latest = manager.latest;

    if (latest == null) {
      return const _IdleHero();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 2, bottom: 10),
            child: Text(
              'LAST DETECTED',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
                letterSpacing: 1.0,
              ),
            ),
          ),
          AlertCard(alert: latest, isLatest: true),
        ],
      ),
    );
  }
}

class _IdleHero extends StatelessWidget {
  const _IdleHero();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hearing_rounded,
                size: 32,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Listening for danger sounds',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Alerts will appear here when a\ndanger sound is detected',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
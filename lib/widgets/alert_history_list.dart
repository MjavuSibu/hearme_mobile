import 'package:flutter/material.dart';
import '../models/sound_alert.dart';
import '../theme/app_theme.dart';
import 'alert_card.dart';

class AlertHistoryList extends StatelessWidget {
  const AlertHistoryList({
    required this.alerts,
    this.onClear,
    super.key,
  });

  final List<SoundAlert> alerts;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 12, 10),
          child: Row(
            children: [
              const Text(
                'History',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${alerts.length}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              if (alerts.isNotEmpty && onClear != null)
                GestureDetector(
                  onTap: onClear,
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (alerts.isEmpty)
          const _EmptyState()
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: alerts.length,
            itemBuilder: (context, index) => AlertCard(
              alert: alerts[index],
              isLatest: index == 0,
            ),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.hearing_outlined,
              size: 40,
              color: AppColors.textMuted.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'No alerts yet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Detected sounds will appear here',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
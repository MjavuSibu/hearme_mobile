import 'package:flutter/material.dart';
import '../models/sound_alert.dart';
import '../theme/app_theme.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({required this.alert, this.isLatest = false, super.key});

  final SoundAlert alert;
  final bool isLatest;

  @override
  Widget build(BuildContext context) {
    final theme = SoundTheme.of(alert.sound);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isLatest ? theme.bg : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLatest ? theme.border : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                _Badge(theme: theme),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.sound,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isLatest ? theme.fg : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        alert.formattedTime,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  alert.confidencePercent,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: theme.fg,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: _ConfidenceBar(
              value: alert.confidence,
              color: theme.fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.theme});

  final SoundTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: theme.fg.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(theme.icon, color: theme.fg, size: 22),
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  const _ConfidenceBar({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Confidence',
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
            Text(
              '${(value * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 5,
            backgroundColor: AppColors.surface,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../services/connection_service.dart' as svc;
import '../theme/app_theme.dart';

class ConnectionStatusPill extends StatelessWidget {
  const ConnectionStatusPill({required this.state, super.key});

  final svc.ConnectionState state;

  @override
  Widget build(BuildContext context) {
    final (dot, label, bg) = switch (state) {
      svc.ConnectionState.connected    => (AppColors.activeGreen, 'Connected',    AppColors.surface),
      svc.ConnectionState.connecting   => (AppColors.accentLight, 'Connecting…',  AppColors.surface),
      svc.ConnectionState.error        => (const Color(0xFFEF4444), 'Error',       AppColors.surface),
      svc.ConnectionState.disconnected => (AppColors.inactiveDot, 'Disconnected', AppColors.surface),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color page = Color(0xFFF5F7FA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFEEF1F6);
  static const Color border = Color(0xFFDDE1EA);

  static const Color textPrimary = Color(0xFF1C2030);
  static const Color textSecondary = Color(0xFF5A6278);
  static const Color textMuted = Color(0xFF9CA3AF);

  static const Color accent = Color(0xFF3D6FE8);
  static const Color accentLight = Color(0xFFEBF0FD);

  static const Color activeGreen = Color(0xFF22C55E);
  static const Color inactiveDot = Color(0xFFCBD5E1);

  static const Color siren = Color(0xFFDC2626);
  static const Color sirenBg = Color(0xFFFEF2F2);
  static const Color sirenBorder = Color(0xFFFECACA);

  static const Color fire = Color(0xFFEA6C0A);
  static const Color fireBg = Color(0xFFFFF7ED);
  static const Color fireBorder = Color(0xFFFED7AA);

  static const Color dog = Color(0xFF16A34A);
  static const Color dogBg = Color(0xFFF0FDF4);
  static const Color dogBorder = Color(0xFFBBF7D0);

  static const Color horn = Color(0xFF3D6FE8);
  static const Color hornBg = Color(0xFFEBF0FD);
  static const Color hornBorder = Color(0xFFBFCFFA);

  static const Color unknown = Color(0xFF64748B);
  static const Color unknownBg = Color(0xFFF8FAFC);
  static const Color unknownBorder = Color(0xFFE2E8F0);
}

class SoundTheme {
  const SoundTheme({
    required this.label,
    required this.fg,
    required this.bg,
    required this.border,
    required this.icon,
  });

  final String label;
  final Color fg;
  final Color bg;
  final Color border;
  final IconData icon;

  static const Map<String, SoundTheme> map = {
    'Emergency Siren': SoundTheme(
      label: 'SIREN',
      fg: AppColors.siren,
      bg: AppColors.sirenBg,
      border: AppColors.sirenBorder,
      icon: Icons.emergency,
    ),
    'Fire Alarm': SoundTheme(
      label: 'FIRE',
      fg: AppColors.fire,
      bg: AppColors.fireBg,
      border: AppColors.fireBorder,
      icon: Icons.local_fire_department,
    ),
    'Dog Barking': SoundTheme(
      label: 'DOG',
      fg: AppColors.dog,
      bg: AppColors.dogBg,
      border: AppColors.dogBorder,
      icon: Icons.pets,
    ),
    'Car Horn': SoundTheme(
      label: 'HORN',
      fg: AppColors.horn,
      bg: AppColors.hornBg,
      border: AppColors.hornBorder,
      icon: Icons.directions_car,
    ),
  };

  static SoundTheme of(String sound) {
    return map[sound] ??
        const SoundTheme(
          label: 'ALERT',
          fg: AppColors.unknown,
          bg: AppColors.unknownBg,
          border: AppColors.unknownBorder,
          icon: Icons.notifications,
        );
  }
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.light,
      surface: AppColors.page,
    ),
    scaffoldBackgroundColor: AppColors.page,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
    ),
  );
}
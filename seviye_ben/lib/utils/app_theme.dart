import 'package:flutter/material.dart';

import '../models/stat_type.dart';

class AppTheme {
  static const Color ink = Color(0xFF141820);
  static const Color street = Color(0xFF1E3A32);
  static const Color streetMid = Color(0xFF2A5246);
  static const Color asphalt = Color(0xFFE6E1D6);
  static const Color panel = Color(0xFFF3EFE6);
  static const Color signal = Color(0xFFE07A3D);
  static const Color xpGold = Color(0xFFF0B429);
  static const Color streak = Color(0xFFE85D4C);
  /// Asphalt üzerinde ikincil metin (≥ WCAG AA).
  static const Color onSurfaceMuted = Color(0xFF3D4556);

  static Color statColor(StatType stat) {
    switch (stat) {
      case StatType.strength:
        return const Color(0xFFC45C2A);
      case StatType.intellect:
        return const Color(0xFF3D6B9A);
      case StatType.energy:
        return const Color(0xFF5A7A3A);
      case StatType.vitality:
        return const Color(0xFF2A8A8A);
    }
  }

  static IconData statIcon(StatType stat) {
    switch (stat) {
      case StatType.strength:
        return Icons.fitness_center;
      case StatType.intellect:
        return Icons.menu_book;
      case StatType.energy:
        return Icons.bedtime;
      case StatType.vitality:
        return Icons.water_drop;
    }
  }

  static BoxDecoration gamePanel({
    Color? borderColor,
    bool glow = false,
  }) {
    return BoxDecoration(
      color: panel,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: borderColor ?? street.withValues(alpha: 0.18),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: ink.withValues(alpha: glow ? 0.12 : 0.06),
          blurRadius: glow ? 16 : 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: street,
        secondary: signal,
        tertiary: xpGold,
        surface: panel,
        onPrimary: Colors.white,
        onSecondary: ink,
        onSurface: ink,
        onSurfaceVariant: onSurfaceMuted,
      ),
      scaffoldBackgroundColor: asphalt,
    );
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: street,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: street.withValues(alpha: 0.12)),
        ),
        margin: const EdgeInsets.only(bottom: 8),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: panel,
        indicatorColor: signal.withValues(alpha: 0.28),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
            color: selected ? street : onSurfaceMuted,
          );
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: signal,
        foregroundColor: ink,
        elevation: 3,
      ),
      chipTheme: base.chipTheme.copyWith(
        selectedColor: signal.withValues(alpha: 0.28),
        side: BorderSide(color: street.withValues(alpha: 0.2)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: ink,
        displayColor: ink,
      ),
    );
  }
}

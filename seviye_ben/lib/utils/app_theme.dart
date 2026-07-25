import 'package:flutter/material.dart';

class AppTheme {
  static const Color ink = Color(0xFF1A1F2E);
  static const Color street = Color(0xFF2E4A3E);
  static const Color asphalt = Color(0xFFE8E4DC);
  static const Color signal = Color(0xFFE07A3D);
  /// Asphalt üzerinde ikincil metin (≥ WCAG AA).
  static const Color onSurfaceMuted = Color(0xFF3D4556);

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: street,
        secondary: signal,
        surface: asphalt,
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
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: signal,
        foregroundColor: ink,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: ink,
        displayColor: ink,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'app_theme.dart';

class SceneBackground {
  const SceneBackground({
    required this.id,
    required this.key,
    required this.name,
    required this.icon,
    required this.skyTop,
    required this.skyBottom,
    required this.ground,
    this.requiredLevel = 1,
    this.requiredStreak = 0,
  });

  final int id;
  final String key;
  final String name;
  final IconData icon;
  final Color skyTop;
  final Color skyBottom;
  final Color ground;
  final int requiredLevel;
  final int requiredStreak;
}

const List<SceneBackground> sceneBackgrounds = [
  SceneBackground(
    id: 0,
    key: 'street',
    name: 'Gündüz sokak',
    icon: Icons.wb_sunny,
    skyTop: Color(0xFFB8D4E8),
    skyBottom: Color(0xFFE8E4DC),
    ground: Color(0xFF5A5E66),
    requiredLevel: 1,
  ),
  SceneBackground(
    id: 1,
    key: 'night',
    name: 'Gece sokağı',
    icon: Icons.nightlight_round,
    skyTop: Color(0xFF0D1526),
    skyBottom: Color(0xFF1A2740),
    ground: Color(0xFF12161F),
    requiredLevel: 5,
  ),
  SceneBackground(
    id: 2,
    key: 'rain',
    name: 'Yağmurlu sokak',
    icon: Icons.water_drop,
    skyTop: Color(0xFF6B7A8A),
    skyBottom: Color(0xFF9AA8B4),
    ground: Color(0xFF3E4550),
    requiredLevel: 8,
  ),
  SceneBackground(
    id: 3,
    key: 'dusk',
    name: 'Akşam ışığı',
    icon: Icons.wb_twilight,
    skyTop: Color(0xFFE07A3D),
    skyBottom: Color(0xFFF0C8A0),
    ground: Color(0xFF4A3F3A),
    requiredLevel: 12,
  ),
  SceneBackground(
    id: 4,
    key: 'neon',
    name: 'Neon cadde',
    icon: Icons.bolt,
    skyTop: Color(0xFF12081F),
    skyBottom: Color(0xFF2A1540),
    ground: Color(0xFF1A1028),
    requiredLevel: 15,
    requiredStreak: 3,
  ),
];

bool isSceneUnlocked(
  SceneBackground scene, {
  required int level,
  required int dayStreak,
}) {
  return level >= scene.requiredLevel && dayStreak >= scene.requiredStreak;
}

String sceneUnlockHint(SceneBackground scene) {
  if (scene.requiredStreak > 0) {
    return 'Sv.${scene.requiredLevel} + ${scene.requiredStreak} gün seri';
  }
  return 'Sv.${scene.requiredLevel}’te açılır';
}

SceneBackground backgroundThemeFor(int index) {
  for (final s in sceneBackgrounds) {
    if (s.id == index) {
      return s;
    }
  }
  return sceneBackgrounds.first;
}

int clampBackgroundTheme(int index) {
  if (index < 0 || index >= sceneBackgrounds.length) {
    return 0;
  }
  return index;
}

/// Kilitli tema seçiliyse açılmış ilk temaya düş.
int resolveUsableBackgroundTheme({
  required int themeIndex,
  required int level,
  required int dayStreak,
}) {
  final clamped = clampBackgroundTheme(themeIndex);
  final current = backgroundThemeFor(clamped);
  if (isSceneUnlocked(current, level: level, dayStreak: dayStreak)) {
    return clamped;
  }
  for (final s in sceneBackgrounds) {
    if (isSceneUnlocked(s, level: level, dayStreak: dayStreak)) {
      return s.id;
    }
  }
  return 0;
}

/// Tema bazlı sokak silueti / yağmur / yıldızlar.
class SceneBackdropPainter extends CustomPainter {
  SceneBackdropPainter({required this.theme});

  final SceneBackground theme;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final sky = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [theme.skyTop, theme.skyBottom],
      ).createShader(rect);
    canvas.drawRect(rect, sky);

    final groundH = size.height * 0.22;
    final groundRect = Rect.fromLTWH(
      0,
      size.height - groundH,
      size.width,
      groundH,
    );
    canvas.drawRect(groundRect, Paint()..color = theme.ground);

    switch (theme.id) {
      case 1:
        _paintNight(canvas, size, groundH);
      case 2:
        _paintRain(canvas, size, groundH);
      case 3:
        _paintDusk(canvas, size, groundH);
      case 4:
        _paintNeon(canvas, size, groundH);
      default:
        _paintStreet(canvas, size, groundH);
    }
  }

  void _paintStreet(Canvas canvas, Size size, double groundH) {
    final baseY = size.height - groundH;
    final building = Paint()..color = AppTheme.ink.withValues(alpha: 0.35);
    final roofs = [
      Rect.fromLTWH(size.width * 0.05, baseY - size.height * 0.28, size.width * 0.22, size.height * 0.28),
      Rect.fromLTWH(size.width * 0.32, baseY - size.height * 0.38, size.width * 0.2, size.height * 0.38),
      Rect.fromLTWH(size.width * 0.72, baseY - size.height * 0.24, size.width * 0.22, size.height * 0.24),
    ];
    for (final r in roofs) {
      canvas.drawRect(r, building);
    }
    final horizon = Paint()
      ..color = AppTheme.street.withValues(alpha: 0.45)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, baseY), Offset(size.width, baseY), horizon);
  }

  void _paintNight(Canvas canvas, Size size, double groundH) {
    final star = Paint()..color = const Color(0xFFE8E4DC).withValues(alpha: 0.85);
    const seeds = [
      Offset(0.12, 0.12),
      Offset(0.28, 0.08),
      Offset(0.45, 0.18),
      Offset(0.62, 0.1),
      Offset(0.78, 0.15),
      Offset(0.88, 0.06),
      Offset(0.2, 0.28),
      Offset(0.55, 0.22),
    ];
    for (final s in seeds) {
      canvas.drawCircle(
        Offset(s.dx * size.width, s.dy * size.height),
        1.4,
        star,
      );
    }

    final lampX = size.width * 0.82;
    final lampY = size.height - groundH - size.height * 0.08;
    canvas.drawCircle(
      Offset(lampX, lampY),
      size.shortestSide * 0.12,
      Paint()..color = AppTheme.signal.withValues(alpha: 0.22),
    );
    canvas.drawCircle(
      Offset(lampX, lampY),
      size.shortestSide * 0.04,
      Paint()..color = AppTheme.signal.withValues(alpha: 0.7),
    );

    final building = Paint()..color = const Color(0xFF0A0E16).withValues(alpha: 0.7);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.08,
        size.height - groundH - size.height * 0.32,
        size.width * 0.25,
        size.height * 0.32,
      ),
      building,
    );
  }

  void _paintRain(Canvas canvas, Size size, double groundH) {
    final rain = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 1.2;
    for (var i = 0; i < 28; i++) {
      final x = (i * 37 % 100) / 100 * size.width;
      final y = (i * 53 % 100) / 100 * (size.height - groundH);
      canvas.drawLine(Offset(x, y), Offset(x + 4, y + 14), rain);
    }
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height - groundH * 0.35),
        width: size.width * 0.55,
        height: groundH * 0.45,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.12),
    );
    final cloud = Paint()..color = const Color(0xFF4A5560).withValues(alpha: 0.45);
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.05, size.width * 0.4, size.height * 0.12),
      cloud,
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.45, size.height * 0.02, size.width * 0.45, size.height * 0.14),
      cloud,
    );
  }

  void _paintDusk(Canvas canvas, Size size, double groundH) {
    final baseY = size.height - groundH;
    final sun = Paint()..color = const Color(0xFFF0B429).withValues(alpha: 0.85);
    canvas.drawCircle(
      Offset(size.width * 0.78, baseY - size.height * 0.08),
      size.shortestSide * 0.1,
      sun,
    );
    final building = Paint()..color = AppTheme.ink.withValues(alpha: 0.4);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.1,
        baseY - size.height * 0.3,
        size.width * 0.22,
        size.height * 0.3,
      ),
      building,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.4,
        baseY - size.height * 0.42,
        size.width * 0.18,
        size.height * 0.42,
      ),
      building,
    );
  }

  void _paintNeon(Canvas canvas, Size size, double groundH) {
    final baseY = size.height - groundH;
    final neonA = Paint()..color = const Color(0xFFE07A3D).withValues(alpha: 0.7);
    final neonB = Paint()..color = const Color(0xFF5B8FA8).withValues(alpha: 0.65);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.12, baseY - size.height * 0.28, size.width * 0.28, size.height * 0.06),
        const Radius.circular(4),
      ),
      neonA,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, baseY - size.height * 0.36, size.width * 0.3, size.height * 0.05),
        const Radius.circular(4),
      ),
      neonB,
    );
    final building = Paint()..color = const Color(0xFF0A0612).withValues(alpha: 0.75);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.08,
        baseY - size.height * 0.4,
        size.width * 0.25,
        size.height * 0.4,
      ),
      building,
    );
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.15),
      2,
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );
  }

  @override
  bool shouldRepaint(covariant SceneBackdropPainter oldDelegate) {
    return oldDelegate.theme.id != theme.id;
  }
}

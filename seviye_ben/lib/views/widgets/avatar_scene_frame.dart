import 'package:flutter/material.dart';

import '../../utils/background_theme.dart';

/// Avatar kartı: seçili sokak atmosferi + çocuk (avatar).
class AvatarSceneFrame extends StatelessWidget {
  const AvatarSceneFrame({
    super.key,
    required this.themeIndex,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final int themeIndex;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = backgroundThemeFor(themeIndex);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: SceneBackdropPainter(theme: theme),
            ),
          ),
          Padding(
            padding: padding,
            child: child,
          ),
        ],
      ),
    );
  }
}

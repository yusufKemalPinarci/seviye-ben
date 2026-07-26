import 'package:flutter/material.dart';

import '../../utils/app_theme.dart';

/// Oyun tarzı XP / görev ilerleme çubuğu.
class XpBar extends StatelessWidget {
  const XpBar({
    super.key,
    required this.progress,
    this.height = 12,
    this.label,
    this.trailing,
    this.color = AppTheme.xpGold,
    this.trackColor,
    this.foregroundColor,
  });

  final double progress;
  final double height;
  final String? label;
  final String? trailing;
  final Color color;
  final Color? trackColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final value = progress.clamp(0.0, 1.0);
    final fg = foregroundColor ?? Theme.of(context).colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null || trailing != null) ...[
          Row(
            children: [
              if (label != null)
                Expanded(
                  child: Text(
                    label!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: fg.withValues(alpha: 0.9),
                        ),
                  ),
                ),
              if (trailing != null)
                Text(
                  trailing!,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        SizedBox(
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  color: trackColor ?? fg.withValues(alpha: 0.14),
                ),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color,
                          Color.lerp(color, Colors.white, 0.35)!,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../models/achievement.dart';
import '../../utils/app_theme.dart';

class AchievementBadgeRow extends StatelessWidget {
  const AchievementBadgeRow({
    super.key,
    required this.unlocked,
  });

  final List<Achievement> unlocked;

  @override
  Widget build(BuildContext context) {
    if (unlocked.isEmpty) {
      return Text(
        'Henüz rozet yok — rutine devam.',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      );
    }

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: unlocked.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final ach = unlocked[index];
          return Tooltip(
            message: ach.title,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppTheme.signal.withValues(alpha: 0.2),
                  child: Icon(
                    ach.kind.icon,
                    color: AppTheme.street,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 64,
                  child: Text(
                    ach.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

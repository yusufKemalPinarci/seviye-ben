import 'package:flutter/material.dart';

import '../../models/daily_quest.dart';
import '../../utils/app_theme.dart';
import 'xp_bar.dart';

class DailyQuestCard extends StatelessWidget {
  const DailyQuestCard({
    super.key,
    required this.quest,
    required this.progress,
    required this.done,
    required this.dayStreak,
  });

  final DailyQuest quest;
  final int progress;
  final bool done;
  final int dayStreak;

  @override
  Widget build(BuildContext context) {
    final ratio = (progress / quest.targetCount).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.gamePanel(
        borderColor: done
            ? AppTheme.street.withValues(alpha: 0.4)
            : AppTheme.street.withValues(alpha: 0.22),
        glow: !done,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (done ? AppTheme.street : AppTheme.signal)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  done ? Icons.emoji_events : Icons.flag,
                  color: done ? AppTheme.street : AppTheme.signal,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  done ? 'Görev tamam!' : 'Günlük görev',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              if (dayStreak > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: AppTheme.streak,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '$dayStreak',
                      style: const TextStyle(
                        color: AppTheme.streak,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            quest.title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
          const SizedBox(height: 2),
          Text(
            quest.description,
            style: TextStyle(color: AppTheme.onSurfaceMuted, height: 1.3),
          ),
          const SizedBox(height: 12),
          XpBar(
            progress: ratio,
            height: 10,
            color: done ? AppTheme.streetMid : AppTheme.signal,
            trackColor: AppTheme.street.withValues(alpha: 0.12),
            trailing: done
                ? '+${quest.bonusXp} XP'
                : '$progress/${quest.targetCount}',
          ),
          if (!done) ...[
            const SizedBox(height: 6),
            Text(
              'Ödül +${quest.bonusXp} XP',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.signal,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

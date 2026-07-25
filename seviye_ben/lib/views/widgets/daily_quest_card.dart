import 'package:flutter/material.dart';

import '../../models/daily_quest.dart';

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
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
        ),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  done ? 'Günlük görev tamam' : 'Günlük görev',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              if (dayStreak > 0)
                Text(
                  'Seri $dayStreak gün',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            quest.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(quest.description),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            done
                ? '+${quest.bonusXp} XP alındı'
                : '$progress / ${quest.targetCount} · ödül +${quest.bonusXp} XP',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

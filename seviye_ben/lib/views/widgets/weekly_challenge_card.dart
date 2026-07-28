import 'package:flutter/material.dart';

import '../../models/weekly_challenge.dart';
import '../../utils/app_theme.dart';
import 'xp_bar.dart';

class WeeklyChallengeCard extends StatelessWidget {
  const WeeklyChallengeCard({
    super.key,
    required this.challenge,
    required this.progressDays,
    required this.done,
  });

  final WeeklyChallenge challenge;
  final int progressDays;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final target = challenge.targetDays;
    final ratio = target == 0 ? 0.0 : (progressDays / target).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.gamePanel(
        borderColor: AppTheme.xpGold.withValues(alpha: 0.45),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month, color: AppTheme.xpGold, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  done ? 'Haftalık meydan tamam' : 'Haftalık meydan',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Text(
                done ? '✓' : '$progressDays/$target',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.xpGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            challenge.title,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          Text(
            challenge.description,
            style: const TextStyle(color: AppTheme.onSurfaceMuted),
          ),
          const SizedBox(height: 12),
          XpBar(
            progress: ratio,
            height: 10,
            color: AppTheme.xpGold,
            trackColor: AppTheme.street.withValues(alpha: 0.12),
            trailing: done
                ? '+${challenge.bonusXp} XP'
                : 'ödül +${challenge.bonusXp} XP',
          ),
        ],
      ),
    );
  }
}

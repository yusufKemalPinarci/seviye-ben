import 'package:flutter/material.dart';

import '../../models/weekly_challenge.dart';
import '../../utils/app_theme.dart';

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
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.signal.withValues(alpha: 0.4),
        ),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            done ? 'Haftalık meydan tamam' : 'Haftalık meydan',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            challenge.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(challenge.description),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              color: AppTheme.signal,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            done
                ? '+${challenge.bonusXp} XP alındı'
                : '$progressDays / $target gün · ödül +${challenge.bonusXp} XP',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

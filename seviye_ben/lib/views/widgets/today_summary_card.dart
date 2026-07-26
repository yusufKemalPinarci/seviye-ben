import 'package:flutter/material.dart';

import '../../utils/app_theme.dart';

class TodaySummaryCard extends StatelessWidget {
  const TodaySummaryCard({
    super.key,
    required this.routinesDone,
    required this.xpEarned,
  });

  final int routinesDone;
  final int xpEarned;

  @override
  Widget build(BuildContext context) {
    final routinesLabel = switch (routinesDone) {
      0 => 'Henüz rutin yok',
      1 => '1 rutin bitti',
      _ => '$routinesDone rutin bitti',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.gamePanel(
        borderColor: AppTheme.signal.withValues(alpha: 0.4),
        glow: xpEarned > 0,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.signal.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.trending_up, color: AppTheme.signal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bugün özeti',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  routinesLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (routinesDone == 0 && xpEarned == 0)
                  Text(
                    'İlk rutini bitir, XP aksın.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.onSurfaceMuted,
                        ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+$xpEarned',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppTheme.signal,
                      height: 1,
                    ),
              ),
              const Text(
                'XP',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.onSurfaceMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.signal.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bugün özeti',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  routinesLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Text(
                '+$xpEarned XP',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.signal,
                    ),
              ),
            ],
          ),
          if (routinesDone == 0 && xpEarned == 0) ...[
            const SizedBox(height: 4),
            Text(
              'İlk rutini bitir, özet dolsun.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

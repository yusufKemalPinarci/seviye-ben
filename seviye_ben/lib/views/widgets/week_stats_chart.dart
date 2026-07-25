import 'package:flutter/material.dart';

import '../../utils/app_theme.dart';
import '../../utils/week_stats.dart';

class WeekStatsChart extends StatelessWidget {
  const WeekStatsChart({super.key, required this.points});

  final List<DayChartPoint> points;

  @override
  Widget build(BuildContext context) {
    final maxXp = points.fold<int>(0, (m, p) => p.stat.xp > m ? p.stat.xp : m);
    final hasData = points.any((p) => p.stat.xp > 0 || p.stat.habits > 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.street.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Son 7 gün',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            'Günlük XP',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          if (!hasData)
            Text(
              'Henüz veri yok — rutin bitir.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            )
          else
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final p in points)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: _DayBar(
                          point: p,
                          maxXp: maxXp == 0 ? 1 : maxXp,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DayBar extends StatelessWidget {
  const _DayBar({required this.point, required this.maxXp});

  final DayChartPoint point;
  final int maxXp;

  @override
  Widget build(BuildContext context) {
    final ratio = (point.stat.xp / maxXp).clamp(0.0, 1.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (point.stat.xp > 0)
          Text(
            '${point.stat.xp}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        const SizedBox(height: 2),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: ratio < 0.04 && point.stat.xp > 0 ? 0.04 : ratio,
              widthFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: point.stat.xp > 0
                      ? AppTheme.signal
                      : AppTheme.street.withValues(alpha: 0.15),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          point.label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        if (point.stat.habits > 0)
          Text(
            '${point.stat.habits}r',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          )
        else
          const SizedBox(height: 12),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../utils/app_theme.dart';
import '../../utils/streak_break.dart';

class StreakBreakBanner extends StatelessWidget {
  const StreakBreakBanner({
    super.key,
    required this.breaks,
    required this.onDismiss,
  });

  final List<StreakBreakInfo> breaks;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    if (breaks.isEmpty) {
      return const SizedBox.shrink();
    }

    final String body;
    if (breaks.length == 1) {
      final b = breaks.first;
      body =
          '“${b.habitTitle}” serisi (${b.lostStreak} gün) durdu. Bugün yeniden başlat.';
    } else {
      final max = breaks.map((b) => b.lostStreak).reduce((a, b) => a > b ? a : b);
      body =
          '${breaks.length} rutinde seri durdu (en uzun $max gün). Bugün yeniden bağla.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E6D3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.signal.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.nightlight_round,
            color: AppTheme.signal.withValues(alpha: 0.9),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seri ara verdi',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.ink,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.onSurfaceMuted,
                        height: 1.35,
                      ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onDismiss,
                    child: const Text('Anladım'),
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

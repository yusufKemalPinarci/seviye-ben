import 'package:flutter/material.dart';

import '../../models/habit.dart';
import '../../models/stat_type.dart';
import '../../utils/app_theme.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.onComplete,
    required this.onEdit,
    required this.onDelete,
  });

  final Habit habit;
  final VoidCallback onComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Silinsin mi?'),
        content: Text('“${habit.title}” kalıcı olarak silinir.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final done = habit.completedToday;
    final accent = AppTheme.statColor(habit.stat);

    return Dismissible(
      key: ValueKey(habit.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onEdit,
          onLongPress: () async {
            final ok = await _confirmDelete(context);
            if (ok) {
              onDelete();
            }
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: AppTheme.gamePanel(
              borderColor: done
                  ? AppTheme.street.withValues(alpha: 0.35)
                  : accent.withValues(alpha: 0.45),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 6,
                    decoration: BoxDecoration(
                      color: done ? AppTheme.street : accent,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(14),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
                      child: Row(
                        children: [
                          Icon(
                            done
                                ? Icons.check_circle
                                : AppTheme.statIcon(habit.stat),
                            color: done ? AppTheme.street : accent,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  habit.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    decoration: done
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: done
                                        ? AppTheme.onSurfaceMuted
                                        : AppTheme.ink,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    _MiniTag(
                                      text: habit.stat.labelTr,
                                      color: accent,
                                    ),
                                    _MiniTag(
                                      text: '+${habit.xpReward} XP',
                                      color: AppTheme.signal,
                                    ),
                                    if (habit.streak > 0)
                                      _MiniTag(
                                        text: 'Seri ${habit.streak}',
                                        color: AppTheme.streak,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (done)
                            const Text(
                              '✓',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: AppTheme.street,
                                fontSize: 18,
                              ),
                            )
                          else
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.signal,
                                foregroundColor: AppTheme.ink,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              onPressed: onComplete,
                              child: const Text('Bitir'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../models/habit.dart';
import '../../models/stat_type.dart';

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
    return Dismissible(
      key: ValueKey(habit.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          onTap: onEdit,
          onLongPress: () async {
            final ok = await _confirmDelete(context);
            if (ok) {
              onDelete();
            }
          },
          leading: Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
          title: Text(
            habit.title,
            style: TextStyle(
              decoration: done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            '${habit.stat.labelTr} · +${habit.xpReward} XP'
            '${habit.streak > 0 ? ' · seri ${habit.streak}' : ''}',
          ),
          trailing: done
              ? const Text('Tamam')
              : TextButton(
                  onPressed: onComplete,
                  child: const Text('Bitir'),
                ),
        ),
      ),
    );
  }
}

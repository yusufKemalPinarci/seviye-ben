import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/habit.dart';
import '../../models/stat_type.dart';
import '../../utils/habit_filter.dart';
import '../../viewmodels/game_notifier.dart';
import '../screens/add_habit_sheet.dart';
import 'habit_tile.dart';

/// Lazy alışkanlık listesi — yalnızca görünür satırlar build edilir.
class HabitListSliver extends ConsumerWidget {
  const HabitListSliver({
    super.key,
    required this.statFilter,
  });

  final StatType? statFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(gameProvider.select((s) => s.habits));
    final filtered = filterHabitsByStat(habits, statFilter);

    if (habits.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Text(
                'Henüz alışkanlık yok.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'İlk rutinini ekle; Bitir’e basınca XP ve seviye gelir.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _addHabit(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Alışkanlık ekle'),
              ),
            ],
          ),
        ),
      );
    }

    if (filtered.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text('Bu kategoride rutin yok.'),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == filtered.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 72),
              child: Text(
                'Düzenlemek için dokun · silmek için sola kaydır veya uzun bas.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          }

          final habit = filtered[index];
          return RepaintBoundary(
            child: HabitTile(
              key: ValueKey(habit.id),
              habit: habit,
              onComplete: () {
                ref.read(gameProvider.notifier).completeHabit(habit.id);
              },
              onEdit: () => _editHabit(context, ref, habit),
              onDelete: () {
                ref.read(gameProvider.notifier).deleteHabit(habit.id);
              },
            ),
          );
        },
        childCount: filtered.length + 1,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
      ),
    );
  }

  Future<void> _editHabit(
    BuildContext context,
    WidgetRef ref,
    Habit habit,
  ) async {
    final result = await showModalBottomSheet<({String title, StatType stat})>(
      context: context,
      isScrollControlled: true,
      builder: (_) => HabitFormSheet(
        initialTitle: habit.title,
        initialStat: habit.stat,
        isEditing: true,
      ),
    );
    if (result != null) {
      await ref
          .read(gameProvider.notifier)
          .updateHabit(habit.id, result.title, result.stat);
    }
  }

  Future<void> _addHabit(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<({String title, StatType stat})>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const HabitFormSheet(),
    );
    if (result != null) {
      await ref.read(gameProvider.notifier).addHabit(result.title, result.stat);
    }
  }
}

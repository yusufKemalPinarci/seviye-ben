import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/achievement.dart';
import '../../models/equipment.dart';
import '../../models/stat_type.dart';
import '../../utils/equipment_look.dart';
import '../../utils/game_balance.dart';
import '../../viewmodels/game_notifier.dart';
import '../widgets/achievement_badge_row.dart';
import '../widgets/animated_character_avatar.dart';
import '../widgets/avatar_scene_frame.dart';
import '../widgets/week_stats_chart.dart';

class CharacterScreen extends ConsumerWidget {
  const CharacterScreen({super.key});

  Future<void> _editName(BuildContext context, WidgetRef ref, String current) async {
    final controller = TextEditingController(text: current);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('İsmini değiştir'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 20,
          decoration: const InputDecoration(
            labelText: 'İsim',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null) {
      await ref.read(gameProvider.notifier).renamePlayer(result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final xpIn = GameBalance.xpProgressInLevel(game.player.xp);
    final xpNeed = GameBalance.xpNeededForNextLevel(game.player.xp);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Karakter'),
        actions: [
          IconButton(
            tooltip: 'İsmi değiştir',
            onPressed: () => _editName(context, ref, game.player.name),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: AvatarSceneFrame(
              themeIndex: game.player.backgroundTheme,
              child: AnimatedCharacterAvatar(
                lookIndex: game.player.lookIndex,
                level: game.level,
                equipped: game.equippedBySlot,
                size: 220,
                enableBounce: false,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            game.player.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            game.title,
            textAlign: TextAlign.center,
          ),
          Text(
            'Seviye ${game.level} · ${game.player.xp} XP'
            '${game.player.dayStreak > 0 ? ' · ${game.player.dayStreak} gün seri' : ''}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: xpNeed == 0 ? 1 : (xpIn / xpNeed).clamp(0.0, 1.0),
            minHeight: 10,
          ),
          const SizedBox(height: 20),
          Text(
            'İstatistikler (taban + ekipman)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...StatType.values.map((stat) {
            final base = switch (stat) {
              StatType.strength => game.player.strength,
              StatType.intellect => game.player.intellect,
              StatType.energy => game.player.energy,
              StatType.vitality => game.player.vitality,
            };
            final bonus = game.bonusFor(stat);
            final total = base + bonus;
            final bar = (total / 40).clamp(0.05, 1.0);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(stat.labelTr)),
                      Text(
                        bonus > 0 ? '$base +$bonus = $total' : '$base',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: bar,
                      minHeight: 6,
                      color: Theme.of(context).colorScheme.secondary,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          WeekStatsChart(points: game.lastSevenDayStats),
          const Divider(height: 32),
          Text(
            'Set bonusları',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Aynı settten 2+ parça giyince ekstra istatistik.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          ...game.setStatuses.map((status) {
            final tier = status.activeTier;
            final subtitle = tier == null
                ? '${status.equippedCount}/3 parça · Set tamamlanmadı'
                : '${status.equippedCount}/3 · +${tier.bonus} ${tier.stat.labelTr}';
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                status.isActive ? Icons.layers : Icons.layers_outlined,
                color: status.isActive
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).disabledColor,
              ),
              title: Text(
                status.set.name,
                style: TextStyle(
                  fontWeight:
                      status.isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              subtitle: Text(subtitle),
            );
          }),
          const Divider(height: 32),
          Text(
            'Giyilenler',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Envanterden giydiğin parçalar avatarında görünür.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          ...EquipSlot.values.map((slot) {
            final eq = game.equippedIn(slot);
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: eq == null
                    ? Theme.of(context).disabledColor.withValues(alpha: 0.2)
                    : equipmentColor(eq.id, slot),
                child: Icon(
                  _slotIcon(slot),
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 18,
                ),
              ),
              title: Text(slot.labelTr),
              subtitle: Text(
                eq == null
                    ? 'Boş'
                    : '${eq.name} (+${eq.bonus} ${eq.stat.labelTr})',
              ),
            );
          }),
          const Divider(height: 32),
          Text(
            'Rozetler',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          AchievementBadgeRow(
            unlocked: game.content.achievements
                .where((a) => game.hasAchievement(a.id))
                .toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Başarımlar',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            '${game.achievementIds.length} / ${game.content.achievements.length}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          ...game.content.achievements.map((ach) {
            final unlocked = game.hasAchievement(ach.id);
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                unlocked ? ach.kind.icon : Icons.lock_outline,
                color: unlocked
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).disabledColor,
              ),
              title: Text(
                ach.title,
                style: TextStyle(
                  fontWeight: unlocked ? FontWeight.w600 : FontWeight.w400,
                  color: unlocked ? null : Theme.of(context).disabledColor,
                ),
              ),
              subtitle: Text(
                unlocked
                    ? '${ach.description} · +${ach.bonusXp} XP'
                    : ach.description,
                style: TextStyle(
                  color: unlocked ? null : Theme.of(context).disabledColor,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  IconData _slotIcon(EquipSlot slot) {
    switch (slot) {
      case EquipSlot.head:
        return Icons.face;
      case EquipSlot.body:
        return Icons.checkroom;
      case EquipSlot.feet:
        return Icons.directions_walk;
      case EquipSlot.accessory:
        return Icons.watch;
    }
  }
}

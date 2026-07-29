import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/achievement.dart';
import '../../models/equipment.dart';
import '../../models/stat_type.dart';
import '../../utils/app_theme.dart';
import '../../utils/background_theme.dart';
import '../../utils/game_balance.dart';
import '../../utils/progression_look.dart';
import '../../viewmodels/game_notifier.dart';
import '../widgets/achievement_badge_row.dart';
import '../widgets/animated_character_avatar.dart';
import '../widgets/avatar_scene_frame.dart';
import '../widgets/gear_silhouette.dart';
import '../widgets/week_stats_chart.dart';
import '../widgets/xp_bar.dart';

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
              themeIndex: resolveUsableBackgroundTheme(
                themeIndex: game.player.backgroundTheme,
                level: game.level,
                dayStreak: game.player.dayStreak,
              ),
              child: AnimatedCharacterAvatar(
                lookIndex: game.player.lookIndex,
                level: game.level,
                equipped: game.equippedBySlot,
                strength: game.player.strength,
                intellect: game.player.intellect,
                energy: game.player.energy,
                vitality: game.player.vitality,
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
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          _StreetIdentityCard(game: game),
          const SizedBox(height: 10),
          XpBar(
            progress: xpNeed == 0 ? 1 : (xpIn / xpNeed).clamp(0.0, 1.0),
            label: 'Seviye ilerlemesi',
            trailing: '$xpIn / $xpNeed XP',
            height: 12,
            color: AppTheme.xpGold,
          ),
          const SizedBox(height: 20),
          Text(
            'İstatistikler',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          Text(
            'Taban + ekipman = güçlenme',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.onSurfaceMuted,
                ),
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
            final color = AppTheme.statColor(stat);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: AppTheme.gamePanel(
                  borderColor: color.withValues(alpha: 0.35),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(AppTheme.statIcon(stat), size: 18, color: color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            stat.labelTr,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        Text(
                          bonus > 0 ? '$base +$bonus = $total' : '$total',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    XpBar(
                      progress: bar,
                      height: 8,
                      color: color,
                      trackColor: color.withValues(alpha: 0.12),
                    ),
                  ],
                ),
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
            final pieceMax = status.set.pieceIds.length;
            final tier = status.activeTier;
            final subtitle = tier == null
                ? '${status.equippedCount}/$pieceMax parça · Set tamamlanmadı'
                : '${status.equippedCount}/$pieceMax · +${tier.bonus} ${tier.stat.labelTr}';
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
              leading: eq == null
                  ? CircleAvatar(
                      backgroundColor:
                          Theme.of(context).disabledColor.withValues(alpha: 0.2),
                      child: Icon(
                        _slotIcon(slot),
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 18,
                      ),
                    )
                  : GearSilhouette(equipment: eq, size: 40),
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
      case EquipSlot.back:
        return Icons.backpack;
      case EquipSlot.feet:
        return Icons.directions_walk;
      case EquipSlot.accessory:
        return Icons.watch;
    }
  }
}

class _StreetIdentityCard extends StatelessWidget {
  const _StreetIdentityCard({required this.game});

  final GameState game;

  @override
  Widget build(BuildContext context) {
    final tier = streetTierForLevel(game.level);
    final activeSets = game.setStatuses.where((s) => s.isActive).toList();
    final setLabel = activeSets.isEmpty
        ? 'Set yok'
        : activeSets.map((s) => s.set.name).join(' · ');
    final scene = backgroundThemeFor(
      resolveUsableBackgroundTheme(
        themeIndex: game.player.backgroundTheme,
        level: game.level,
        dayStreak: game.player.dayStreak,
      ),
    );
    final unlockedBadges = game.content.achievements
        .where((a) => game.hasAchievement(a.id))
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.gamePanel(
        borderColor: tier.ringColor.withValues(alpha: 0.45),
        glow: true,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sokak kimliği',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _IdentityChip(
                icon: Icons.military_tech,
                label: game.title,
                color: AppTheme.xpGold,
              ),
              _IdentityChip(
                icon: Icons.trending_up,
                label: '${tier.nameTr} · Sv.${game.level}',
                color: tier.ringColor,
              ),
              if (game.player.dayStreak > 0)
                _IdentityChip(
                  icon: Icons.local_fire_department,
                  label: '${game.player.dayStreak} gün seri',
                  color: AppTheme.streak,
                ),
              _IdentityChip(
                icon: Icons.layers,
                label: setLabel,
                color: AppTheme.street,
              ),
              _IdentityChip(
                icon: scene.icon,
                label: scene.name,
                color: AppTheme.signal,
              ),
            ],
          ),
          if (unlockedBadges.isNotEmpty) ...[
            const SizedBox(height: 12),
            AchievementBadgeRow(unlocked: unlockedBadges),
          ],
        ],
      ),
    );
  }
}

class _IdentityChip extends StatelessWidget {
  const _IdentityChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: AppTheme.ink,
            ),
          ),
        ],
      ),
    );
  }
}

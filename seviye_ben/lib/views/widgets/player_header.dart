import 'package:flutter/material.dart';

import '../../models/equipment.dart';
import '../../models/player.dart';
import 'animated_character_avatar.dart';

class PlayerHeader extends StatelessWidget {
  const PlayerHeader({
    super.key,
    required this.player,
    required this.level,
    required this.title,
    required this.xpInLevel,
    required this.xpNeeded,
    required this.equipped,
    this.habitCompletePulse = 0,
  });

  final Player player;
  final int level;
  final String title;
  final int xpInLevel;
  final int xpNeeded;
  final Map<EquipSlot, Equipment?> equipped;
  final int habitCompletePulse;

  @override
  Widget build(BuildContext context) {
    final progress = xpNeeded == 0 ? 1.0 : xpInLevel / xpNeeded;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: AnimatedCharacterAvatar(
                    lookIndex: player.lookIndex,
                    level: level,
                    equipped: equipped,
                    size: 88,
                    showLevelBadge: false,
                    habitCompletePulse: habitCompletePulse,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Seviye $level · ${player.xp} XP'
                      '${player.dayStreak > 0 ? ' · ${player.dayStreak} gün seri' : ''}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: Colors.white24,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$xpInLevel / $xpNeeded XP',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatChip(label: 'Güç', value: player.strength),
              _StatChip(label: 'Zeka', value: player.intellect),
              _StatChip(label: 'Enerji', value: player.energy),
              _StatChip(label: 'Can', value: player.vitality),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Column(
      children: [
        Text(
          '$value',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: onPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: onPrimary,
              ),
        ),
      ],
    );
  }
}

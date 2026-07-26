import 'package:flutter/material.dart';

import '../../models/equipment.dart';
import '../../models/player.dart';
import '../../models/stat_type.dart';
import '../../utils/app_theme.dart';
import 'animated_character_avatar.dart';
import 'xp_bar.dart';

class PlayerHeader extends StatelessWidget {
  const PlayerHeader({
    super.key,
    required this.player,
    required this.level,
    required this.title,
    required this.xpInLevel,
    required this.xpNeeded,
    required this.equipped,
    required this.gearBonuses,
    this.habitCompletePulse = 0,
  });

  final Player player;
  final int level;
  final String title;
  final int xpInLevel;
  final int xpNeeded;
  final Map<EquipSlot, Equipment?> equipped;
  final Map<StatType, int> gearBonuses;
  final int habitCompletePulse;

  int _base(StatType s) => switch (s) {
        StatType.strength => player.strength,
        StatType.intellect => player.intellect,
        StatType.energy => player.energy,
        StatType.vitality => player.vitality,
      };

  @override
  Widget build(BuildContext context) {
    final progress = xpNeeded == 0 ? 1.0 : xpInLevel / xpNeeded;
    final streak = player.dayStreak;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.street,
            AppTheme.streetMid,
            Color(0xFF16352C),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.ink.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppTheme.signal.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.xpGold.withValues(alpha: 0.65),
                        width: 2,
                      ),
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    child: AnimatedCharacterAvatar(
                      lookIndex: player.lookIndex,
                      level: level,
                      equipped: equipped,
                      size: 96,
                      showLevelBadge: false,
                      habitCompletePulse: habitCompletePulse,
                    ),
                  ),
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.signal,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white70, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.signal.withValues(alpha: 0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        'Sv.$level',
                        style: const TextStyle(
                          color: AppTheme.ink,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _HudChip(
                          icon: Icons.military_tech,
                          label: title,
                          color: AppTheme.xpGold,
                        ),
                        if (streak > 0)
                          _HudChip(
                            icon: Icons.local_fire_department,
                            label: '$streak gün seri',
                            color: AppTheme.streak,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toplam ${player.xp} XP',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          XpBar(
            progress: progress,
            label: 'Sonraki seviye',
            trailing: '$xpInLevel / $xpNeeded XP',
            height: 11,
            foregroundColor: Colors.white,
            trackColor: Colors.black.withValues(alpha: 0.28),
          ),
          const SizedBox(height: 14),
          Row(
            children: StatType.values.map((stat) {
              final base = _base(stat);
              final bonus = gearBonuses[stat] ?? 0;
              final total = base + bonus;
              return Expanded(
                child: _StatPill(
                  stat: stat,
                  total: total,
                  bonus: bonus,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _HudChip extends StatelessWidget {
  const _HudChip({
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.stat,
    required this.total,
    required this.bonus,
  });

  final StatType stat;
  final int total;
  final int bonus;

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.statColor(stat);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.withValues(alpha: 0.55)),
        ),
        child: Column(
          children: [
            Icon(AppTheme.statIcon(stat), size: 16, color: c),
            const SizedBox(height: 4),
            Text(
              '$total',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            Text(
              bonus > 0 ? '${stat.labelTr} +$bonus' : stat.labelTr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

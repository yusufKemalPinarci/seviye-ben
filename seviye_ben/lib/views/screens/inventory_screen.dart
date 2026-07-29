import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/equipment.dart';
import '../../models/stat_type.dart';
import '../../utils/background_theme.dart';
import '../../utils/equipment_look.dart';
import '../../viewmodels/game_notifier.dart';
import '../widgets/animated_character_avatar.dart';
import '../widgets/avatar_scene_frame.dart';
import '../widgets/gear_silhouette.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final all = game.content.equipment;
    final unlocked = game.unlockedEquipment;
    final themeIndex = resolveUsableBackgroundTheme(
      themeIndex: game.player.backgroundTheme,
      level: game.level,
      dayStreak: game.player.dayStreak,
    );
    final scene = backgroundThemeFor(themeIndex);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Envanter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Semantics(
            label: 'Karakter önizlemesi, ${scene.name} arka planı',
            child: Center(
              child: AvatarSceneFrame(
                themeIndex: themeIndex,
                child: AnimatedCharacterAvatar(
                  key: ValueKey(
                    EquipSlot.values
                        .map((s) => game.equipped[s.name] ?? '-')
                        .join('|'),
                  ),
                  lookIndex: game.player.lookIndex,
                  level: game.level,
                  equipped: game.equippedBySlot,
                  strength: game.player.strength,
                  intellect: game.player.intellect,
                  energy: game.player.energy,
                  vitality: game.player.vitality,
                  size: 200,
                  enableBounce: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Giydiğin her parça avatarında katman katman görünür.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          Text(
            'Üzerinde',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: EquipSlot.values.map((slot) {
              final eq = game.equippedIn(slot);
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: eq == null
                      ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
                      : equipmentColor(eq.id, slot).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: eq == null
                        ? scheme.outlineVariant
                        : equipmentColor(eq.id, slot),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: eq == null
                            ? scheme.outlineVariant
                            : equipmentColor(eq.id, slot),
                        shape: BoxShape.circle,
                        border: Border.all(color: scheme.onSurface, width: 0.8),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      eq == null
                          ? '${slot.labelTr}: boş'
                          : '${slot.labelTr}: ${eq.name}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          Text(
            'Açık: ${unlocked.length} / ${all.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...all.map((eq) {
            final isUnlocked = game.unlockedIds.contains(eq.id);
            final isEquipped = game.equipped[eq.slot.name] == eq.id;
            final canEquip = isUnlocked && game.level >= eq.requiredLevel;
            final currentInSlot = game.equippedIn(eq.slot);
            final replaces = !isEquipped &&
                currentInSlot != null &&
                currentInSlot.id != eq.id;
            final setName = eq.setId == null
                ? null
                : game.content.setById(eq.setId!)?.name;
            final color = equipmentColor(eq.id, eq.slot);

            return Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.25),
                  child: GearSilhouette(
                    equipment: eq,
                    size: 28,
                    locked: !isUnlocked,
                  ),
                ),
                title: Text(eq.name),
                subtitle: Text(
                  '${eq.slot.labelTr} · Sv.${eq.requiredLevel} · '
                  '+${eq.bonus} ${eq.stat.labelTr}'
                  '${setName != null ? ' · $setName' : ''}\n'
                  '${eq.description}'
                  '${replaces ? '\n→ ${currentInSlot.name} yerine giyilir' : ''}',
                ),
                isThreeLine: true,
                trailing: !isUnlocked
                    ? Text(
                        'Kilitli',
                        style: TextStyle(color: scheme.outline),
                      )
                    : isEquipped
                        ? TextButton(
                            onPressed: () {
                              ref.read(gameProvider.notifier).unequip(eq.slot);
                            },
                            child: const Text('Çıkar'),
                          )
                        : FilledButton(
                            onPressed: canEquip
                                ? () {
                                    ref
                                        .read(gameProvider.notifier)
                                        .equip(eq.id);
                                  }
                                : null,
                            child: Text(replaces ? 'Değiştir' : 'Giy'),
                          ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/equipment.dart';
import '../../models/stat_type.dart';
import '../../utils/background_theme.dart';
import '../../viewmodels/game_notifier.dart';
import '../widgets/animated_character_avatar.dart';
import '../widgets/avatar_scene_frame.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final all = game.content.equipment;
    final unlocked = game.unlockedEquipment;
    final scene = backgroundThemeFor(game.player.backgroundTheme);

    return Scaffold(
      appBar: AppBar(title: const Text('Envanter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Semantics(
            label: 'Karakter önizlemesi, ${scene.name} arka planı',
            child: Center(
              child: AvatarSceneFrame(
                themeIndex: game.player.backgroundTheme,
                child: AnimatedCharacterAvatar(
                  lookIndex: game.player.lookIndex,
                  level: game.level,
                  equipped: game.equippedBySlot,
                  size: 180,
                  enableBounce: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Giydiğin parçalar anında burada görünür.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Text(
            'Açık: ${unlocked.length} / ${all.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...all.map((eq) {
            final isUnlocked = game.unlockedIds.contains(eq.id);
            final isEquipped = game.equipped[eq.slot.name] == eq.id;
            final canEquip = isUnlocked && game.level >= eq.requiredLevel;
            final setName = eq.setId == null
                ? null
                : game.content.setById(eq.setId!)?.name;

            return Card(
              child: ListTile(
                title: Text(eq.name),
                subtitle: Text(
                  '${eq.slot.labelTr} · Sv.${eq.requiredLevel} · '
                  '+${eq.bonus} ${eq.stat.labelTr}'
                  '${setName != null ? ' · $setName' : ''}\n'
                  '${eq.description}',
                ),
                isThreeLine: true,
                trailing: !isUnlocked
                    ? const Text('Kilitli')
                    : isEquipped
                        ? TextButton(
                            onPressed: () {
                              ref
                                  .read(gameProvider.notifier)
                                  .unequip(eq.slot);
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
                            child: const Text('Giy'),
                          ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

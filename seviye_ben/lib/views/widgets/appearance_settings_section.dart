import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/background_theme.dart';
import '../../utils/equipment_look.dart';
import '../../utils/settings_strings.dart';
import '../../viewmodels/game_notifier.dart';

class AppearanceSettingsSection extends ConsumerWidget {
  const AppearanceSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SettingsStrings.lookTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          SettingsStrings.lookHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: lookStyles.map((style) {
            final selected = game.player.lookIndex == style.id;
            return ChoiceChip(
              selected: selected,
              label: Text(style.name),
              avatar: CircleAvatar(
                backgroundColor: style.skin,
                radius: 8,
              ),
              onSelected: (_) {
                ref.read(gameProvider.notifier).setLookIndex(style.id);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text(
          SettingsStrings.atmosphereTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          SettingsStrings.atmosphereHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sceneBackgrounds.map((scene) {
            final unlocked = isSceneUnlocked(
              scene,
              level: game.level,
              dayStreak: game.player.dayStreak,
            );
            final selected = game.player.backgroundTheme == scene.id;
            return ChoiceChip(
              selected: selected && unlocked,
              label: Text(
                unlocked ? scene.name : '${scene.name} (${sceneUnlockHint(scene)})',
              ),
              avatar: Icon(
                unlocked ? scene.icon : Icons.lock_outline,
                size: 16,
              ),
              onSelected: unlocked
                  ? (_) {
                      ref
                          .read(gameProvider.notifier)
                          .setBackgroundTheme(scene.id);
                    }
                  : null,
            );
          }).toList(),
        ),
      ],
    );
  }
}

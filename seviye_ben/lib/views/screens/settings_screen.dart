import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/settings_strings.dart';
import '../../viewmodels/game_notifier.dart';
import '../widgets/appearance_settings_section.dart';
import '../widgets/backup_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(SettingsStrings.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            SettingsStrings.sectionFeedback,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(SettingsStrings.hapticTitle),
            subtitle: Text(
              game.hapticEnabled
                  ? SettingsStrings.hapticOn
                  : SettingsStrings.hapticOff,
            ),
            value: game.hapticEnabled,
            onChanged: (v) {
              ref.read(gameProvider.notifier).setHapticEnabled(v);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(SettingsStrings.soundTitle),
            subtitle: Text(
              game.soundEnabled
                  ? SettingsStrings.soundOn
                  : SettingsStrings.soundOff,
            ),
            value: game.soundEnabled,
            onChanged: (v) {
              ref.read(gameProvider.notifier).setSoundEnabled(v);
            },
          ),
          const SizedBox(height: 20),
          Text(
            SettingsStrings.sectionAppearance,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const AppearanceSettingsSection(),
          const SizedBox(height: 20),
          Text(
            SettingsStrings.sectionAccessibility,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.text_fields,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: const Text(SettingsStrings.fontScaleInfoTitle),
            subtitle: Text(
              SettingsStrings.fontScaleInfoBody,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            SettingsStrings.sectionData,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const BackupSection(),
        ],
      ),
    );
  }
}

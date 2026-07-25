import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:seviye_ben/services/haptic_service.dart';
import 'package:seviye_ben/services/local_store.dart';
import 'package:seviye_ben/services/sound_service.dart';
import 'package:seviye_ben/utils/settings_strings.dart';
import 'package:seviye_ben/viewmodels/game_notifier.dart';
import 'package:seviye_ben/views/screens/settings_screen.dart';
import 'package:seviye_ben/views/widgets/backup_section.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() async {
    SoundService.enabled = false;
    HapticService.enabled = false;
    tempDir = await Directory.systemTemp.createTemp('seviye_ben_set_');
    Hive.init(tempDir.path);
    await LocalStore.init();
  });

  tearDownAll(() async {
    try {
      await Hive.close().timeout(const Duration(seconds: 2));
    } catch (_) {}
    if (tempDir.existsSync()) {
      try {
        await tempDir.delete(recursive: true);
      } catch (_) {}
    }
  });

  testWidgets('Ayarlar ekranı bölümleri görünür', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pump();

    expect(find.text(SettingsStrings.title), findsOneWidget);
    expect(find.text(SettingsStrings.sectionFeedback), findsOneWidget);
    expect(find.text(SettingsStrings.hapticTitle), findsOneWidget);
    expect(find.text(SettingsStrings.soundTitle), findsOneWidget);
    expect(find.text(SettingsStrings.sectionAppearance), findsOneWidget);
    expect(find.text(SettingsStrings.sectionAccessibility), findsOneWidget);
    expect(find.text(SettingsStrings.fontScaleInfoTitle), findsOneWidget);
    expect(find.text(SettingsStrings.sectionData), findsOneWidget);
    expect(find.byType(BackupSection), findsOneWidget);
  });

  test('haptic toggle Hive’a yazılır', () async {
    final n = GameNotifier();
    expect(n.state.hapticEnabled, isTrue);
    await n.setHapticEnabled(false);
    expect(n.state.hapticEnabled, isFalse);
    expect(LocalStore.isHapticEnabled(), isFalse);
    expect(HapticService.enabled, isFalse);
    await n.setHapticEnabled(true);
    expect(LocalStore.isHapticEnabled(), isTrue);
  });
}

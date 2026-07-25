import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:seviye_ben/models/equipment.dart';
import 'package:seviye_ben/services/local_store.dart';
import 'package:seviye_ben/services/sound_service.dart';
import 'package:seviye_ben/viewmodels/game_notifier.dart';
import 'package:seviye_ben/views/screens/inventory_screen.dart';
import 'package:seviye_ben/views/widgets/animated_character_avatar.dart';
import 'package:seviye_ben/views/widgets/avatar_scene_frame.dart';
import 'package:seviye_ben/views/widgets/character_avatar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() async {
    SoundService.enabled = false;
    tempDir = await Directory.systemTemp.createTemp('seviye_ben_inv_');
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

  test('equip Hive’a yazar', () async {
    final notifier = GameNotifier();
    await notifier.equip('eq_bere').timeout(const Duration(seconds: 5));
    expect(notifier.state.equipped['head'], 'eq_bere');
    expect(LocalStore.loadEquipped()['head'], 'eq_bere');
    await notifier.unequip(EquipSlot.head).timeout(const Duration(seconds: 5));
    expect(notifier.state.equipped['head'], isNull);
  });

  testWidgets('Envanter canlı avatar önizlemesi gösterir', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: InventoryScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(AvatarSceneFrame), findsOneWidget);
    expect(find.byType(AnimatedCharacterAvatar), findsOneWidget);
    expect(find.byType(CharacterAvatar), findsOneWidget);
    expect(
      find.text('Giydiğin parçalar anında burada görünür.'),
      findsOneWidget,
    );
    expect(find.text('Envanter'), findsOneWidget);
  });
}

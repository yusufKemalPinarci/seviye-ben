import 'dart:io';
import 'dart:ui' show Size;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:seviye_ben/main.dart';
import 'package:seviye_ben/services/local_store.dart';
import 'package:seviye_ben/services/sound_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() async {
    SoundService.enabled = false;
    tempDir = await Directory.systemTemp.createTemp('seviye_ben_widget_');
    Hive.init(tempDir.path);
    await LocalStore.init();
    await LocalStore.setOnboardingDone();
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

  testWidgets('SeviyeBen ana ekran başlığı görünür', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ProviderScope(child: SeviyeBenApp()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('SeviyeBen'), findsWidgets);
    expect(find.text('Sokak notu'), findsOneWidget);
    expect(find.text('Bugünün görevleri'), findsOneWidget);
    expect(find.text('Bugünün hedefleri'), findsOneWidget);
    expect(find.textContaining('Günlük'), findsWidgets);
  });
}

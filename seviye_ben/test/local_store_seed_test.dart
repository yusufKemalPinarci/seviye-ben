import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:seviye_ben/services/local_store.dart';
import 'package:seviye_ben/services/sound_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    SoundService.enabled = false;
    tempDir = await Directory.systemTemp.createTemp('seviye_ben_seed_');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    try {
      await Hive.close().timeout(const Duration(seconds: 2));
    } catch (_) {}
    if (tempDir.existsSync()) {
      try {
        await tempDir.delete(recursive: true);
      } catch (_) {}
    }
  });

  test('ilk init içerik alışkanlıklarını seedler', () async {
    await LocalStore.init();
    final habits = LocalStore.loadHabits();
    expect(habits, isNotEmpty);
    expect(habits.any((h) => h.id == 'habit_yuru'), isTrue);
    expect(
      Hive.box('settings').get('contentHabitsSeeded'),
      isTrue,
    );
  });

  test('silinen content habit ikinci init’te geri gelmez', () async {
    await LocalStore.init();
    await LocalStore.deleteHabit('habit_yuru');
    expect(
      LocalStore.loadHabits().any((h) => h.id == 'habit_yuru'),
      isFalse,
    );

    await LocalStore.init();
    expect(
      LocalStore.loadHabits().any((h) => h.id == 'habit_yuru'),
      isFalse,
    );
  });

  test('tüm habitler silinse bile reseed olmaz', () async {
    await LocalStore.init();
    for (final h in List.of(LocalStore.loadHabits())) {
      await LocalStore.deleteHabit(h.id);
    }
    expect(LocalStore.loadHabits(), isEmpty);

    await LocalStore.init();
    expect(LocalStore.loadHabits(), isEmpty);
  });
}

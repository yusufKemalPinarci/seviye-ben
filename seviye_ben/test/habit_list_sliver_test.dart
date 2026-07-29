import 'dart:io';
import 'dart:ui' show Size;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:seviye_ben/models/habit.dart';
import 'package:seviye_ben/models/stat_type.dart';
import 'package:seviye_ben/services/local_store.dart';
import 'package:seviye_ben/services/sound_service.dart';
import 'package:seviye_ben/viewmodels/game_notifier.dart';
import 'package:seviye_ben/views/widgets/habit_list_sliver.dart';
import 'package:seviye_ben/views/widgets/habit_tile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() async {
    SoundService.enabled = false;
    tempDir = await Directory.systemTemp.createTemp('seviye_ben_habit_list_');
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

  testWidgets('50+ alışkanlıkta viewport dışı tile peşin build edilmez',
      (tester) async {
    final notifier = GameNotifier();
    notifier.debugSetHabits([
      for (var i = 0; i < 55; i++)
        Habit(
          id: 'bulk_$i',
          title: 'Rutin $i',
          stat: StatType.strength,
        ),
    ]);
    expect(notifier.state.habits, hasLength(55));

    await tester.binding.setSurfaceSize(const Size(400, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameProvider.overrideWith((ref) => notifier),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                HabitListSliver(statFilter: null),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final built = tester.widgetList(find.byType(HabitTile)).length;
    expect(built, lessThan(50));
    expect(built, greaterThan(0));
  });

  testWidgets('filtre boşsa kategori mesajı', (tester) async {
    final notifier = GameNotifier();
    notifier.debugSetHabits([
      Habit(id: 'only_str', title: 'Güç', stat: StatType.strength),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameProvider.overrideWith((ref) => notifier),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                HabitListSliver(statFilter: StatType.energy),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Bu kategoride rutin yok.'), findsOneWidget);
  });

  testWidgets('boş listede Alışkanlık ekle CTA', (tester) async {
    final notifier = GameNotifier();
    notifier.debugSetHabits(const []);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameProvider.overrideWith((ref) => notifier),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                HabitListSliver(statFilter: null),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Henüz alışkanlık yok.'), findsOneWidget);
    expect(find.text('Alışkanlık ekle'), findsOneWidget);
  });
}

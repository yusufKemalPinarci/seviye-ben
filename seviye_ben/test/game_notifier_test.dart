import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:seviye_ben/models/equipment.dart';
import 'package:seviye_ben/models/player.dart';
import 'package:seviye_ben/services/content_loader.dart';
import 'package:seviye_ben/services/local_store.dart';
import 'package:seviye_ben/services/sound_service.dart';
import 'package:seviye_ben/utils/date_keys.dart';
import 'package:seviye_ben/utils/game_balance.dart';
import 'package:seviye_ben/viewmodels/game_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() async {
    SoundService.enabled = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      return null;
    });
    tempDir = await Directory.systemTemp.createTemp('seviye_ben_gn_');
    Hive.init(tempDir.path);
    await LocalStore.init();
  });

  tearDown(() async {
    await Hive.box('player').clear();
    await Hive.box('habits').clear();
    await Hive.box('inventory').clear();
    await Hive.box('settings').clear();
    await LocalStore.init();
  });

  tearDownAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
    try {
      await Hive.close().timeout(const Duration(seconds: 2));
    } catch (_) {}
    if (tempDir.existsSync()) {
      try {
        await tempDir.delete(recursive: true);
      } catch (_) {}
    }
  });

  Future<GameNotifier> freshNotifier() async {
    return GameNotifier();
  }

  Future<void> savePlayer(Player player) async {
    await LocalStore.savePlayer(player);
  }

  group('completeHabit — temel', () {
    test('XP, stat ve streak kaydeder', () async {
      final n = await freshNotifier();
      final habit = n.state.habits.firstWhere((h) => h.id == 'habit_yuru');
      final xpBefore = n.state.player.xp;
      final strBefore = n.state.player.strength;

      await n.completeHabit(habit.id).timeout(const Duration(seconds: 5));

      final updated = n.state.habits.firstWhere((h) => h.id == habit.id);
      expect(updated.completedToday, isTrue);
      expect(updated.streak, 1);
      expect(updated.lastCompletedDate, todayKey());
      expect(n.state.player.strength, strBefore + 1);
      final expectedGain =
          habit.xpReward + GameBalance.streakBonus(1);
      expect(n.state.player.xp, greaterThanOrEqualTo(xpBefore + expectedGain));
      expect(LocalStore.loadPlayer().xp, n.state.player.xp);
    });
  });

  group('completeHabit — koruma', () {
    test('geçersiz id no-op', () async {
      final n = await freshNotifier();
      final xp = n.state.player.xp;
      await n.completeHabit('yok_id').timeout(const Duration(seconds: 5));
      expect(n.state.player.xp, xp);
    });

    test('aynı gün tekrar no-op', () async {
      final n = await freshNotifier();
      final id = n.state.habits.first.id;
      await n.completeHabit(id).timeout(const Duration(seconds: 5));
      final xp = n.state.player.xp;
      final pulse = n.state.habitCompletePulse;
      await n.completeHabit(id).timeout(const Duration(seconds: 5));
      expect(n.state.player.xp, xp);
      expect(n.state.habitCompletePulse, pulse);
    });
  });

  group('completeHabit — seri', () {
    test('dün bitmiş habit streak artırır', () async {
      final seed = await freshNotifier();
      final habit = seed.state.habits.first;
      await LocalStore.saveHabit(
        habit.copyWith(streak: 1, lastCompletedDate: yesterdayKey()),
      );
      final n = await freshNotifier();
      final beforeXp = n.state.player.xp;
      await n.completeHabit(habit.id).timeout(const Duration(seconds: 5));
      final updated = n.state.habits.firstWhere((h) => h.id == habit.id);
      expect(updated.streak, 2);
      final gain = habit.xpReward + GameBalance.streakBonus(2);
      expect(n.state.player.xp, greaterThanOrEqualTo(beforeXp + gain));
    });
  });

  group('completeHabit — günlük görev', () {
    test('hedefe ulaşınca bonus ve flag', () async {
      final n = await freshNotifier();
      final quest = n.state.todaysQuest;
      final incomplete = n.state.habits.where((h) => !h.completedToday).toList();
      expect(incomplete.length, greaterThanOrEqualTo(quest.targetCount));

      for (var i = 0; i < quest.targetCount; i++) {
        await n
            .completeHabit(incomplete[i].id)
            .timeout(const Duration(seconds: 5));
      }

      expect(n.state.dailyQuestJustCompleted, isTrue);
      expect(n.state.dailyQuestBonusXp, quest.bonusXp);
      expect(n.state.player.dailyQuestCompletedDate, todayKey());
      expect(n.state.isDailyQuestDone, isTrue);
    });

    test('aynı gün ikinci kez günlük bonus yok', () async {
      final n = await freshNotifier();
      final quest = n.state.todaysQuest;
      final incomplete = n.state.habits.where((h) => !h.completedToday).toList();
      for (var i = 0; i < quest.targetCount; i++) {
        await n
            .completeHabit(incomplete[i].id)
            .timeout(const Duration(seconds: 5));
      }
      n.clearFeedbackFlags();
      final next = n.state.habits.firstWhere((h) => !h.completedToday);
      await n.completeHabit(next.id).timeout(const Duration(seconds: 5));
      expect(n.state.dailyQuestJustCompleted, isFalse);
      expect(n.state.dailyQuestBonusXp, isNull);
    });
  });

  group('başarım', () {
    test('ilk rutin başarımı', () async {
      final n = await freshNotifier();
      expect(n.state.achievementIds, isEmpty);
      await n
          .completeHabit(n.state.habits.first.id)
          .timeout(const Duration(seconds: 5));
      expect(n.state.achievementIds, contains('ach_ilk_rutin'));
      expect(LocalStore.loadAchievementIds(), contains('ach_ilk_rutin'));
      expect(n.state.lastAchievementTitles, isNotEmpty);
    });

    test('günlük görev başarımı', () async {
      final n = await freshNotifier();
      final quest = n.state.todaysQuest;
      final incomplete = n.state.habits.where((h) => !h.completedToday).toList();
      for (var i = 0; i < quest.targetCount; i++) {
        await n
            .completeHabit(incomplete[i].id)
            .timeout(const Duration(seconds: 5));
      }
      expect(n.state.achievementIds, contains('ach_gunluk'));
    });
  });

  group('haftalık meydan', () {
    test('7. aktif günde ödül', () async {
      final week = weekStartKey();
      final start = parseDayKey(week)!;
      final today = todayKey();
      final prior = <String>[];
      for (var i = 0; i < 7; i++) {
        final key = todayKey(start.add(Duration(days: i)));
        if (key != today) {
          prior.add(key);
        }
      }
      await savePlayer(Player(weeklyActiveDates: prior));
      final n = await freshNotifier();
      final weekly = n.state.thisWeeksChallenge;
      expect(prior.length + 1, greaterThanOrEqualTo(weekly.targetDays));

      await n
          .completeHabit(n.state.habits.first.id)
          .timeout(const Duration(seconds: 5));

      expect(n.state.weeklyChallengeJustCompleted, isTrue);
      expect(n.state.weeklyChallengeBonusXp, weekly.bonusXp);
      expect(n.state.player.weeklyRewardWeekKey, week);
    });
  });

  group('seviye ve pulse', () {
    test('seviye atlamada lastLevelUp ve pulse artmaz', () async {
      final need = GameBalance.xpForLevel(2);
      await savePlayer(Player(xp: need - 5));
      final n = await freshNotifier();
      expect(n.state.level, 1);
      final pulseBefore = n.state.habitCompletePulse;

      await n
          .completeHabit(n.state.habits.first.id)
          .timeout(const Duration(seconds: 5));

      expect(n.state.level, greaterThanOrEqualTo(2));
      expect(n.state.lastLevelUp, isNotNull);
      expect(n.state.habitCompletePulse, pulseBefore);
      expect(n.state.unlockedIds.length, greaterThanOrEqualTo(2));
    });

    test('seviye yokken habitCompletePulse artar', () async {
      final n = await freshNotifier();
      final before = n.state.habitCompletePulse;
      await n
          .completeHabit(n.state.habits.first.id)
          .timeout(const Duration(seconds: 5));
      if (n.state.lastLevelUp == null) {
        expect(n.state.habitCompletePulse, before + 1);
      }
    });
  });

  group('checkBrokenStreaks', () {
    test('kırık seriyi sıfırlar', () async {
      final seed = await freshNotifier();
      final habit = seed.state.habits.first;
      final twoDaysAgo = todayKey(
        DateTime.now().subtract(const Duration(days: 2)),
      );
      await LocalStore.saveHabit(
        habit.copyWith(streak: 5, lastCompletedDate: twoDaysAgo),
      );
      final n = await freshNotifier();
      await n.checkBrokenStreaks().timeout(const Duration(seconds: 5));
      expect(n.state.streakBreaks, isNotEmpty);
      expect(
        n.state.habits.firstWhere((h) => h.id == habit.id).streak,
        0,
      );
    });
  });

  group('equip ve clearFeedback', () {
    test('equip Hive’a yazar', () async {
      final n = await freshNotifier();
      await n.equip('eq_bere').timeout(const Duration(seconds: 5));
      expect(n.state.equipped['head'], 'eq_bere');
      expect(LocalStore.loadEquipped()['head'], 'eq_bere');
      await n.unequip(EquipSlot.head).timeout(const Duration(seconds: 5));
      expect(n.state.equipped['head'], isNull);
    });

    test('clearFeedbackFlags temizler', () async {
      final n = await freshNotifier();
      await n
          .completeHabit(n.state.habits.first.id)
          .timeout(const Duration(seconds: 5));
      n.clearFeedbackFlags();
      expect(n.state.lastLevelUp, isNull);
      expect(n.state.dailyQuestJustCompleted, isFalse);
      expect(n.state.lastAchievementTitles, isEmpty);
      expect(n.state.weeklyChallengeJustCompleted, isFalse);
    });
  });
}

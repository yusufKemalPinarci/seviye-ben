import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/achievement.dart';
import '../models/daily_quest.dart';
import '../models/equipment.dart';
import '../models/habit.dart';
import '../models/player.dart';
import '../models/stat_type.dart';
import '../models/weekly_challenge.dart';
import '../services/content_loader.dart';
import '../services/haptic_service.dart';
import '../services/local_store.dart';
import '../services/sound_service.dart';
import '../utils/background_theme.dart';
import '../utils/date_keys.dart';
import '../utils/game_balance.dart';
import '../utils/set_bonus.dart';
import '../utils/streak_break.dart';
import '../utils/titles.dart';
import '../utils/week_stats.dart';

class GameState {
  const GameState({
    required this.player,
    required this.habits,
    required this.unlockedIds,
    required this.equipped,
    required this.achievementIds,
    this.soundEnabled = true,
    this.hapticEnabled = true,
    this.lastLevelUp,
    this.lastUnlockNames = const [],
    this.levelMessage,
    this.dailyQuestJustCompleted = false,
    this.dailyQuestBonusXp,
    this.lastAchievementTitles = const [],
    this.streakBreaks = const [],
    this.weeklyChallengeJustCompleted = false,
    this.weeklyChallengeBonusXp,
    this.habitCompletePulse = 0,
  });

  final Player player;
  final List<Habit> habits;
  final List<String> unlockedIds;
  final Map<String, String> equipped;
  final List<String> achievementIds;
  final bool soundEnabled;
  final bool hapticEnabled;
  final int? lastLevelUp;
  final List<String> lastUnlockNames;
  final String? levelMessage;
  final bool dailyQuestJustCompleted;
  final int? dailyQuestBonusXp;
  final List<String> lastAchievementTitles;
  final List<StreakBreakInfo> streakBreaks;
  final bool weeklyChallengeJustCompleted;
  final int? weeklyChallengeBonusXp;
  /// Bitir animasyonu tetikleyicisi (monoton artan; seviye atlamada artmaz).
  final int habitCompletePulse;

  int get level => GameBalance.levelFromXp(player.xp);

  String get title => titleForLevel(level, content.titles);

  GameContent get content => ContentLoader.requireCache;

  DailyQuest get todaysQuest => content.todaysQuest();

  WeeklyChallenge get thisWeeksChallenge => content.thisWeeksChallenge();

  int get completedHabitsToday =>
      habits.where((h) => h.completedToday).length;

  int get xpEarnedToday => player.xpEarnedOn(todayKey());

  List<DayChartPoint> get lastSevenDayStats =>
      lastNDayStats(player.dailyStats);

  bool get isDailyQuestDone => player.dailyQuestDoneToday(todayKey());

  int get weeklyDaysProgress {
    final week = weekStartKey();
    return datesInWeek(player.weeklyActiveDates, week).length;
  }

  bool get isWeeklyChallengeDone =>
      player.weeklyRewardClaimedFor(weekStartKey());

  List<Equipment> get unlockedEquipment {
    return unlockedIds
        .map(content.equipmentById)
        .whereType<Equipment>()
        .toList();
  }

  Equipment? equippedIn(EquipSlot slot) {
    final id = equipped[slot.name];
    if (id == null) {
      return null;
    }
    return content.equipmentById(id);
  }

  int bonusFor(StatType stat) {
    var total = 0;
    for (final slot in EquipSlot.values) {
      final eq = equippedIn(slot);
      if (eq != null && eq.stat == stat) {
        total += eq.bonus;
      }
    }
    total += setBonusForStat(content.equipmentSets, equippedBySlot, stat);
    return total;
  }

  List<ActiveSetStatus> get setStatuses =>
      activeSetStatuses(content.equipmentSets, equippedBySlot);

  bool hasAchievement(String id) => achievementIds.contains(id);

  Map<EquipSlot, Equipment?> get equippedBySlot {
    return {
      for (final slot in EquipSlot.values) slot: equippedIn(slot),
    };
  }

  GameState copyWith({
    Player? player,
    List<Habit>? habits,
    List<String>? unlockedIds,
    Map<String, String>? equipped,
    List<String>? achievementIds,
    bool? soundEnabled,
    bool? hapticEnabled,
    int? lastLevelUp,
    List<String>? lastUnlockNames,
    String? levelMessage,
    bool? dailyQuestJustCompleted,
    int? dailyQuestBonusXp,
    List<String>? lastAchievementTitles,
    List<StreakBreakInfo>? streakBreaks,
    bool? weeklyChallengeJustCompleted,
    int? weeklyChallengeBonusXp,
    int? habitCompletePulse,
    bool clearLevelUp = false,
    bool clearUnlocks = false,
    bool clearLevelMessage = false,
    bool clearDailyQuestFlag = false,
    bool clearAchievements = false,
    bool clearStreakBreaks = false,
    bool clearWeeklyChallengeFlag = false,
  }) {
    return GameState(
      player: player ?? this.player,
      habits: habits ?? this.habits,
      unlockedIds: unlockedIds ?? this.unlockedIds,
      equipped: equipped ?? this.equipped,
      achievementIds: achievementIds ?? this.achievementIds,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      lastLevelUp: clearLevelUp ? null : (lastLevelUp ?? this.lastLevelUp),
      lastUnlockNames:
          clearUnlocks ? const [] : (lastUnlockNames ?? this.lastUnlockNames),
      levelMessage:
          clearLevelMessage ? null : (levelMessage ?? this.levelMessage),
      dailyQuestJustCompleted: clearDailyQuestFlag
          ? false
          : (dailyQuestJustCompleted ?? this.dailyQuestJustCompleted),
      dailyQuestBonusXp: clearDailyQuestFlag
          ? null
          : (dailyQuestBonusXp ?? this.dailyQuestBonusXp),
      lastAchievementTitles: clearAchievements
          ? const []
          : (lastAchievementTitles ?? this.lastAchievementTitles),
      streakBreaks: clearStreakBreaks
          ? const []
          : (streakBreaks ?? this.streakBreaks),
      weeklyChallengeJustCompleted: clearWeeklyChallengeFlag
          ? false
          : (weeklyChallengeJustCompleted ?? this.weeklyChallengeJustCompleted),
      weeklyChallengeBonusXp: clearWeeklyChallengeFlag
          ? null
          : (weeklyChallengeBonusXp ?? this.weeklyChallengeBonusXp),
      habitCompletePulse: habitCompletePulse ?? this.habitCompletePulse,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier()
      : super(
          GameState(
            player: LocalStore.loadPlayer(),
            habits: LocalStore.loadHabits(),
            unlockedIds: LocalStore.loadUnlocked(),
            equipped: LocalStore.loadEquipped(),
            achievementIds: LocalStore.loadAchievementIds(),
            soundEnabled: LocalStore.isSoundEnabled(),
            hapticEnabled: LocalStore.isHapticEnabled(),
          ),
        ) {
    SoundService.enabled = state.soundEnabled;
    HapticService.enabled = state.hapticEnabled;
    LocalStore.persistEquippedMigration(state.equipped, state.unlockedIds);
  }

  void reloadFromStore() {
    state = GameState(
      player: LocalStore.loadPlayer(),
      habits: LocalStore.loadHabits(),
      unlockedIds: LocalStore.loadUnlocked(),
      equipped: LocalStore.loadEquipped(),
      achievementIds: LocalStore.loadAchievementIds(),
      soundEnabled: LocalStore.isSoundEnabled(),
      hapticEnabled: LocalStore.isHapticEnabled(),
    );
    SoundService.enabled = state.soundEnabled;
    HapticService.enabled = state.hapticEnabled;
  }

  @visibleForTesting
  void debugSetHabits(List<Habit> habits) {
    state = state.copyWith(habits: habits);
  }

  Future<void> completeHabit(String habitId) async {
    final index = state.habits.indexWhere((h) => h.id == habitId);
    if (index < 0) {
      return;
    }
    final habit = state.habits[index];
    if (habit.completedToday) {
      return;
    }

    await HapticService.lightImpact();

    final today = todayKey();
    var habitStreak = 1;
    if (habit.lastCompletedDate != null) {
      final last = DateTime.tryParse(habit.lastCompletedDate!);
      if (last != null) {
        final lastDay = DateTime(last.year, last.month, last.day);
        final yParsed = DateTime.tryParse(yesterdayKey());
        if (yParsed != null && lastDay == yParsed) {
          habitStreak = habit.streak + 1;
        }
      }
    }

    final streakBonus = GameBalance.streakBonus(habitStreak);
    var gainedXp = habit.xpReward + streakBonus;

    final updated = habit.copyWith(
      streak: habitStreak,
      lastCompletedDate: today,
    );
    final habits = [...state.habits];
    habits[index] = updated;

    var player = _applyDayStreak(state.player, today);
    player = _bumpStat(player, habit.stat);
    player = player.recordHabitDone(today);

    final completedToday = habits.where((h) => h.completedToday).length;
    final quest = state.content.todaysQuest();
    var dailyJustDone = false;
    int? dailyBonus;

    if (!player.dailyQuestDoneToday(today) &&
        GameBalance.isDailyQuestComplete(
          completedCount: completedToday,
          targetCount: quest.targetCount,
        )) {
      gainedXp += quest.bonusXp;
      player = player.copyWith(dailyQuestCompletedDate: today);
      dailyJustDone = true;
      dailyBonus = quest.bonusXp;
    }

    final week = weekStartKey();
    final weekDates = datesInWeek(player.weeklyActiveDates, week);
    if (!weekDates.contains(today)) {
      player = player.copyWith(
        weeklyActiveDates: [...player.weeklyActiveDates, today],
      );
    }

    final weekly = state.content.thisWeeksChallenge();
    var weeklyJustDone = false;
    int? weeklyBonus;
    final weeklyProgress = datesInWeek(player.weeklyActiveDates, week).length;
    if (!player.weeklyRewardClaimedFor(week) &&
        weeklyProgress >= weekly.targetDays) {
      gainedXp += weekly.bonusXp;
      player = player.copyWith(weeklyRewardWeekKey: week);
      weeklyJustDone = true;
      weeklyBonus = weekly.bonusXp;
    }

    final oldLevel = GameBalance.levelFromXp(player.xp);
    player = player.creditXp(gainedXp, today);
    var newLevel = GameBalance.levelFromXp(player.xp);

    await LocalStore.saveHabit(updated);
    await LocalStore.savePlayer(player);

    var unlockedIds = state.unlockedIds;
    var unlockNames = <String>[];
    String? levelMessage;
    if (newLevel > oldLevel) {
      final newly = await LocalStore.unlockForLevel(newLevel, state.content);
      unlockedIds = LocalStore.loadUnlocked();
      unlockNames = newly
          .map(state.content.equipmentById)
          .whereType<Equipment>()
          .map((e) => e.name)
          .toList();
      levelMessage = state.content.messageForLevel(newLevel);
      await HapticService.mediumImpact();
      await SoundService.playLevelUp();
    } else {
      await SoundService.playHabitDone();
    }

    final leveledUp = newLevel > oldLevel;
    state = state.copyWith(
      player: player,
      habits: habits,
      unlockedIds: unlockedIds,
      lastLevelUp: leveledUp ? newLevel : null,
      lastUnlockNames: unlockNames,
      levelMessage: levelMessage,
      dailyQuestJustCompleted: dailyJustDone,
      dailyQuestBonusXp: dailyBonus,
      weeklyChallengeJustCompleted: weeklyJustDone,
      weeklyChallengeBonusXp: weeklyBonus,
      habitCompletePulse:
          leveledUp ? null : state.habitCompletePulse + 1,
      clearLevelUp: !leveledUp,
      clearUnlocks: unlockNames.isEmpty,
      clearLevelMessage: levelMessage == null,
      clearDailyQuestFlag: !dailyJustDone,
      clearWeeklyChallengeFlag: !weeklyJustDone,
      clearAchievements: true,
    );

    await syncAchievements();
  }

  /// Geriye dönük + yeni başarımları kontrol eder; bonus XP verir.
  Future<void> syncAchievements() async {
    final earned = _newlyEarnedAchievements(
      player: state.player,
      habits: state.habits,
      level: state.level,
      already: state.achievementIds,
    );
    if (earned.isEmpty) {
      return;
    }

    final ids = [...state.achievementIds, ...earned.map((a) => a.id)];
    await LocalStore.saveAchievementIds(ids);

    final bonusXp = earned.fold<int>(0, (sum, a) => sum + a.bonusXp);
    var player = state.player;
    var unlockedIds = state.unlockedIds;
    var unlockNames = [...state.lastUnlockNames];
    var lastLevelUp = state.lastLevelUp;
    var levelMessage = state.levelMessage;

    if (bonusXp > 0) {
      final today = todayKey();
      final oldLevel = GameBalance.levelFromXp(player.xp);
      player = player.creditXp(bonusXp, today);
      final newLevel = GameBalance.levelFromXp(player.xp);
      await LocalStore.savePlayer(player);
      if (newLevel > oldLevel) {
        final newly = await LocalStore.unlockForLevel(newLevel, state.content);
        unlockedIds = LocalStore.loadUnlocked();
        unlockNames = [
          ...unlockNames,
          ...newly
              .map(state.content.equipmentById)
              .whereType<Equipment>()
              .map((e) => e.name),
        ];
        lastLevelUp = newLevel;
        levelMessage = state.content.messageForLevel(newLevel) ?? levelMessage;
        await HapticService.mediumImpact();
        await SoundService.playLevelUp();
      }
    }

    state = state.copyWith(
      player: player,
      unlockedIds: unlockedIds,
      achievementIds: ids,
      lastLevelUp: lastLevelUp,
      lastUnlockNames: unlockNames,
      levelMessage: levelMessage,
      lastAchievementTitles: earned.map((a) => a.title).toList(),
      clearLevelUp: lastLevelUp == null,
      clearUnlocks: unlockNames.isEmpty,
      clearLevelMessage: levelMessage == null,
    );
  }

  List<Achievement> _newlyEarnedAchievements({
    required Player player,
    required List<Habit> habits,
    required int level,
    required List<String> already,
  }) {
    final result = <Achievement>[];
    for (final ach in state.content.achievements) {
      if (already.contains(ach.id)) {
        continue;
      }
      if (_isMet(
        ach,
        player: player,
        habits: habits,
        level: level,
        unlockedCount: state.unlockedIds.length,
      )) {
        result.add(ach);
      }
    }
    return result;
  }

  bool _isMet(
    Achievement ach, {
    required Player player,
    required List<Habit> habits,
    required int level,
    required int unlockedCount,
  }) {
    switch (ach.kind) {
      case AchievementKind.level:
        return level >= ach.target;
      case AchievementKind.dayStreak:
        return player.dayStreak >= ach.target;
      case AchievementKind.habitStreak:
        var maxStreak = 0;
        for (final h in habits) {
          if (h.streak > maxStreak) {
            maxStreak = h.streak;
          }
        }
        return maxStreak >= ach.target;
      case AchievementKind.anyHabit:
        return habits.any((h) => h.lastCompletedDate != null);
      case AchievementKind.dailyQuest:
        return player.dailyQuestCompletedDate != null;
      case AchievementKind.weeklyChallenge:
        return player.weeklyRewardWeekKey != null;
      case AchievementKind.habitCount:
        return habits.length >= ach.target;
      case AchievementKind.unlockCount:
        return unlockedCount >= ach.target;
      case AchievementKind.xpTotal:
        return player.xp >= ach.target;
    }
  }

  Player _bumpStat(Player player, StatType stat) {
    switch (stat) {
      case StatType.strength:
        return player.copyWith(strength: player.strength + 1);
      case StatType.intellect:
        return player.copyWith(intellect: player.intellect + 1);
      case StatType.energy:
        return player.copyWith(energy: player.energy + 1);
      case StatType.vitality:
        return player.copyWith(vitality: player.vitality + 1);
    }
  }

  Player _applyDayStreak(Player player, String today) {
    if (player.lastActiveDate == today) {
      return player;
    }
    final nextStreak =
        player.lastActiveDate == yesterdayKey() ? player.dayStreak + 1 : 1;
    return player.copyWith(
      dayStreak: nextStreak,
      lastActiveDate: today,
    );
  }

  Future<void> deleteHabit(String habitId) async {
    await LocalStore.deleteHabit(habitId);
    state = state.copyWith(
      habits: state.habits.where((h) => h.id != habitId).toList(),
    );
  }

  Future<void> completeOnboarding(String name) async {
    final trimmed = name.trim().isEmpty ? 'Gezgin' : name.trim();
    final player = state.player.copyWith(name: trimmed);
    await LocalStore.savePlayer(player);
    await LocalStore.setOnboardingDone();
    state = state.copyWith(player: player);
  }

  Future<void> addHabit(String title, StatType stat) async {
    final habit = Habit(
      id: const Uuid().v4(),
      title: title,
      stat: stat,
    );
    await LocalStore.addHabit(habit);
    state = state.copyWith(habits: [...state.habits, habit]);
  }

  Future<void> updateHabit(String habitId, String title, StatType stat) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final index = state.habits.indexWhere((h) => h.id == habitId);
    if (index < 0) {
      return;
    }
    final updated = state.habits[index].copyWith(title: trimmed, stat: stat);
    final habits = [...state.habits];
    habits[index] = updated;
    await LocalStore.saveHabit(updated);
    state = state.copyWith(habits: habits);
  }

  Future<void> renamePlayer(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final player = state.player.copyWith(name: trimmed);
    await LocalStore.savePlayer(player);
    state = state.copyWith(player: player);
  }

  Future<void> setLookIndex(int index) async {
    final clamped = index.clamp(0, 2);
    if (clamped == state.player.lookIndex) {
      return;
    }
    final player = state.player.copyWith(lookIndex: clamped);
    await LocalStore.savePlayer(player);
    state = state.copyWith(player: player);
  }

  Future<void> setBackgroundTheme(int index) async {
    final clamped = clampBackgroundTheme(index);
    if (clamped == state.player.backgroundTheme) {
      return;
    }
    final player = state.player.copyWith(backgroundTheme: clamped);
    await LocalStore.savePlayer(player);
    state = state.copyWith(player: player);
  }

  Future<void> equip(String equipmentId) async {
    final eq = state.content.equipmentById(equipmentId);
    if (eq == null || !state.unlockedIds.contains(equipmentId)) {
      return;
    }
    if (eq.requiredLevel > state.level) {
      return;
    }
    final next = Map<String, String>.from(state.equipped);
    next[eq.slot.name] = eq.id;
    await LocalStore.saveInventory(
      unlocked: state.unlockedIds,
      equipped: next,
    );
    state = state.copyWith(equipped: next);
  }

  Future<void> unequip(EquipSlot slot) async {
    final next = Map<String, String>.from(state.equipped)..remove(slot.name);
    await LocalStore.saveInventory(
      unlocked: state.unlockedIds,
      equipped: next,
    );
    state = state.copyWith(equipped: next);
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await LocalStore.setSoundEnabled(enabled);
    SoundService.enabled = enabled;
    state = state.copyWith(soundEnabled: enabled);
  }

  Future<void> setHapticEnabled(bool enabled) async {
    await LocalStore.setHapticEnabled(enabled);
    HapticService.enabled = enabled;
    state = state.copyWith(hapticEnabled: enabled);
  }

  void clearFeedbackFlags() {
    state = state.copyWith(
      clearLevelUp: true,
      clearUnlocks: true,
      clearLevelMessage: true,
      clearDailyQuestFlag: true,
      clearAchievements: true,
      clearWeeklyChallengeFlag: true,
    );
  }

  void clearStreakBreakNotice() {
    state = state.copyWith(clearStreakBreaks: true);
  }

  /// Kırılmış alışkanlık serilerini sıfırlar ve yumuşak uyarı state’i set eder.
  Future<void> checkBrokenStreaks() async {
    final broken = findBrokenStreaks(state.habits);
    if (broken.isEmpty) {
      return;
    }

    final habits = state.habits.map((h) {
      if (!isHabitStreakBroken(h)) {
        return h;
      }
      return h.copyWith(streak: 0);
    }).toList();

    for (final h in habits) {
      if (state.habits.any((old) => old.id == h.id && old.streak != h.streak)) {
        await LocalStore.saveHabit(h);
      }
    }

    state = state.copyWith(
      habits: habits,
      streakBreaks: broken,
    );
  }
}

final gameProvider =
    StateNotifierProvider<GameNotifier, GameState>((ref) => GameNotifier());

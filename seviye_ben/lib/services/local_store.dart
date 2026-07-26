import 'package:hive_flutter/hive_flutter.dart';

import '../models/habit.dart';
import '../models/player.dart';
import 'content_loader.dart';

class LocalStore {
  LocalStore._();

  static const _playerBox = 'player';
  static const _habitsBox = 'habits';
  static const _inventoryBox = 'inventory';
  static const _settingsBox = 'settings';

  static Future<void> init() async {
    await Hive.openBox(_playerBox);
    await Hive.openBox(_habitsBox);
    await Hive.openBox(_inventoryBox);
    await Hive.openBox(_settingsBox);

    final content = await ContentLoader.load();
    final habits = Hive.box(_habitsBox);
    if (habits.isEmpty) {
      for (final h in seedHabitsFromContent(content)) {
        await habits.put(h.id, h.toJson());
      }
    } else {
      for (final h in seedHabitsFromContent(content)) {
        if (!habits.containsKey(h.id)) {
          await habits.put(h.id, h.toJson());
        }
      }
    }

    final player = Hive.box(_playerBox);
    if (!player.containsKey('profile')) {
      await player.put('profile', Player().toJson());
    }

    final inv = Hive.box(_inventoryBox);
    if (!inv.containsKey('unlocked')) {
      await inv.put('unlocked', <String>[]);
    }
    if (!inv.containsKey('equipped')) {
      await inv.put('equipped', <String, String>{});
    }

    await unlockForLevel(1, content);
  }

  static bool isOnboardingDone() {
    return Hive.box(_settingsBox).get('onboardingDone', defaultValue: false)
        as bool;
  }

  static Future<void> setOnboardingDone() async {
    await Hive.box(_settingsBox).put('onboardingDone', true);
  }

  static bool isSoundEnabled() {
    return Hive.box(_settingsBox).get('soundEnabled', defaultValue: true)
        as bool;
  }

  static Future<void> setSoundEnabled(bool enabled) async {
    await Hive.box(_settingsBox).put('soundEnabled', enabled);
  }

  static bool isHapticEnabled() {
    return Hive.box(_settingsBox).get('hapticEnabled', defaultValue: true)
        as bool;
  }

  static Future<void> setHapticEnabled(bool enabled) async {
    await Hive.box(_settingsBox).put('hapticEnabled', enabled);
  }

  static List<String> loadAchievementIds() {
    final raw = Hive.box(_settingsBox).get('achievementIds');
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return [];
  }

  static Future<void> saveAchievementIds(List<String> ids) async {
    await Hive.box(_settingsBox).put('achievementIds', ids);
  }

  static Player loadPlayer() {
    final raw = Hive.box(_playerBox).get('profile') as Map?;
    if (raw == null) {
      return Player();
    }
    return Player.fromJson(Map<String, dynamic>.from(raw));
  }

  static Future<void> savePlayer(Player player) async {
    await Hive.box(_playerBox).put('profile', player.toJson());
  }

  static List<Habit> loadHabits() {
    final box = Hive.box(_habitsBox);
    return box.values
        .map((e) => Habit.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  static Future<void> saveHabit(Habit habit) async {
    await Hive.box(_habitsBox).put(habit.id, habit.toJson());
  }

  static Future<void> addHabit(Habit habit) async {
    await saveHabit(habit);
  }

  static Future<void> deleteHabit(String id) async {
    await Hive.box(_habitsBox).delete(id);
  }

  static List<String> loadUnlocked() {
    final raw = Hive.box(_inventoryBox).get('unlocked');
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return [];
  }

  static Map<String, String> loadEquipped() {
    final raw = Hive.box(_inventoryBox).get('equipped');
    if (raw is! Map) {
      return {};
    }
    final map = raw.map((k, v) => MapEntry(k.toString(), v.toString()));
    // Eski kayıt: çanta body'deydi → sırt slotuna taşı
    if (map['body'] == 'eq_sirt_cantasi') {
      map['back'] = 'eq_sirt_cantasi';
      map.remove('body');
    }
    return map;
  }

  /// Hive'da hâlâ body→çanta varsa migrate edilmiş map'i yazar.
  static Future<void> persistEquippedMigration(
    Map<String, String> equipped,
    List<String> unlocked,
  ) async {
    final raw = Hive.box(_inventoryBox).get('equipped');
    if (raw is Map && raw['body'] == 'eq_sirt_cantasi') {
      await saveInventory(unlocked: unlocked, equipped: equipped);
    }
  }

  static Future<void> saveInventory({
    required List<String> unlocked,
    required Map<String, String> equipped,
  }) async {
    final box = Hive.box(_inventoryBox);
    await box.put('unlocked', unlocked);
    await box.put('equipped', equipped);
  }

  static Future<List<String>> unlockForLevel(
    int level,
    GameContent content,
  ) async {
    final unlocked = loadUnlocked();
    final newly = <String>[];
    for (final eq in content.equipment) {
      if (eq.requiredLevel <= level && !unlocked.contains(eq.id)) {
        unlocked.add(eq.id);
        newly.add(eq.id);
      }
    }
    if (newly.isNotEmpty) {
      await saveInventory(unlocked: unlocked, equipped: loadEquipped());
    }
    return newly;
  }

  static Map<String, dynamic> exportSnapshot() {
    return {
      'player': loadPlayer().toJson(),
      'habits': loadHabits().map((h) => h.toJson()).toList(),
      'inventory': {
        'unlocked': loadUnlocked(),
        'equipped': loadEquipped(),
      },
      'settings': {
        'onboardingDone': isOnboardingDone(),
        'soundEnabled': isSoundEnabled(),
        'hapticEnabled': isHapticEnabled(),
        'achievementIds': loadAchievementIds(),
      },
    };
  }

  static Future<void> importSnapshot(Map<String, dynamic> data) async {
    final player = Player.fromJson(
      Map<String, dynamic>.from(data['player'] as Map),
    );
    final habits = (data['habits'] as List)
        .map((e) => Habit.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final inv = Map<String, dynamic>.from(data['inventory'] as Map);
    final unlocked = (inv['unlocked'] as List).map((e) => e.toString()).toList();
    final equippedRaw = inv['equipped'] as Map? ?? {};
    final equipped = equippedRaw.map(
      (k, v) => MapEntry(k.toString(), v.toString()),
    );
    final settings = Map<String, dynamic>.from(data['settings'] as Map);
    final achievementIds = (settings['achievementIds'] as List? ?? [])
        .map((e) => e.toString())
        .toList();
    final onboardingDone = settings['onboardingDone'] as bool? ?? true;
    final soundEnabled = settings['soundEnabled'] as bool? ?? true;
    final hapticEnabled = settings['hapticEnabled'] as bool? ?? true;

    final habitsBox = Hive.box(_habitsBox);
    await habitsBox.clear();
    for (final h in habits) {
      await habitsBox.put(h.id, h.toJson());
    }
    await savePlayer(player);
    await saveInventory(unlocked: unlocked, equipped: equipped);
    final settingsBox = Hive.box(_settingsBox);
    await settingsBox.put('onboardingDone', onboardingDone);
    await settingsBox.put('soundEnabled', soundEnabled);
    await settingsBox.put('hapticEnabled', hapticEnabled);
    await settingsBox.put('achievementIds', achievementIds);
  }
}

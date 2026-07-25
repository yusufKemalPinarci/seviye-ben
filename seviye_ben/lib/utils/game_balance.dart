class GameBalance {
  static const int baseHabitXp = 10;
  static const int streakBonusPerDay = 2;
  static const int maxStreakBonus = 20;

  /// Seri gününe göre bonus XP (`min(seri × 2, 20)`).
  static int streakBonus(int streakDays) {
    if (streakDays <= 0) {
      return 0;
    }
    return (streakDays * streakBonusPerDay).clamp(0, maxStreakBonus);
  }

  /// Seviye n için gereken toplam XP (kümülatif).
  static int xpForLevel(int level) {
    if (level <= 1) {
      return 0;
    }
    var total = 0;
    for (var i = 2; i <= level; i++) {
      total += 40 + (i * 15);
    }
    return total;
  }

  static int levelFromXp(int xp) {
    var level = 1;
    while (xpForLevel(level + 1) <= xp) {
      level++;
      if (level >= 99) {
        break;
      }
    }
    return level;
  }

  static int xpProgressInLevel(int xp) {
    final level = levelFromXp(xp);
    return xp - xpForLevel(level);
  }

  static int xpNeededForNextLevel(int xp) {
    final level = levelFromXp(xp);
    return xpForLevel(level + 1) - xpForLevel(level);
  }

  static bool isDailyQuestComplete({
    required int completedCount,
    required int targetCount,
  }) {
    return completedCount >= targetCount;
  }
}

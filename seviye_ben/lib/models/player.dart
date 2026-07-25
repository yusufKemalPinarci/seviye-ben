class DayStat {
  const DayStat({this.xp = 0, this.habits = 0});

  final int xp;
  final int habits;

  DayStat copyWith({int? xp, int? habits}) {
    return DayStat(xp: xp ?? this.xp, habits: habits ?? this.habits);
  }

  Map<String, dynamic> toJson() => {'xp': xp, 'habits': habits};

  factory DayStat.fromJson(Map<String, dynamic> json) {
    return DayStat(
      xp: json['xp'] as int? ?? 0,
      habits: json['habits'] as int? ?? 0,
    );
  }
}

class Player {
  Player({
    this.name = 'Gezgin',
    this.xp = 0,
    this.strength = 1,
    this.intellect = 1,
    this.energy = 1,
    this.vitality = 1,
    this.dayStreak = 0,
    this.lastActiveDate,
    this.dailyQuestCompletedDate,
    this.lookIndex = 0,
    this.backgroundTheme = 0,
    this.xpEarnedToday = 0,
    this.xpEarnedDate,
    this.weeklyActiveDates = const [],
    this.weeklyRewardWeekKey,
    this.dailyStats = const {},
  });

  static const int dailyStatsRetainDays = 14;

  final String name;
  final int xp;
  final int strength;
  final int intellect;
  final int energy;
  final int vitality;
  final int dayStreak;
  final String? lastActiveDate;
  final String? dailyQuestCompletedDate;
  final int lookIndex;
  /// 0 street · 1 night · 2 rain
  final int backgroundTheme;
  final int xpEarnedToday;
  final String? xpEarnedDate;
  final List<String> weeklyActiveDates;
  final String? weeklyRewardWeekKey;
  final Map<String, DayStat> dailyStats;

  bool dailyQuestDoneToday(String today) => dailyQuestCompletedDate == today;

  bool weeklyRewardClaimedFor(String weekStart) =>
      weeklyRewardWeekKey == weekStart;

  int xpEarnedOn(String today) {
    if (xpEarnedDate != today) {
      return 0;
    }
    return xpEarnedToday;
  }

  /// Toplam XP + bugünün XP sayacı + günlük geçmiş.
  Player creditXp(int amount, String today) {
    final earned = xpEarnedDate == today ? xpEarnedToday : 0;
    final prev = dailyStats[today] ?? const DayStat();
    final nextStats = Map<String, DayStat>.from(dailyStats)
      ..[today] = prev.copyWith(xp: prev.xp + amount);
    return copyWith(
      xp: xp + amount,
      xpEarnedToday: earned + amount,
      xpEarnedDate: today,
      dailyStats: _pruneDailyStats(nextStats, today),
    );
  }

  Player recordHabitDone(String today) {
    final prev = dailyStats[today] ?? const DayStat();
    final nextStats = Map<String, DayStat>.from(dailyStats)
      ..[today] = prev.copyWith(habits: prev.habits + 1);
    return copyWith(dailyStats: _pruneDailyStats(nextStats, today));
  }

  static Map<String, DayStat> _pruneDailyStats(
    Map<String, DayStat> stats,
    String today,
  ) {
    final parsed = DateTime.tryParse(today);
    if (parsed == null) {
      return stats;
    }
    final cutoff = parsed.subtract(const Duration(days: dailyStatsRetainDays));
    final cutoffKey =
        '${cutoff.year.toString().padLeft(4, '0')}-'
        '${cutoff.month.toString().padLeft(2, '0')}-'
        '${cutoff.day.toString().padLeft(2, '0')}';
    return Map.fromEntries(
      stats.entries.where((e) => e.key.compareTo(cutoffKey) >= 0),
    );
  }

  Player copyWith({
    String? name,
    int? xp,
    int? strength,
    int? intellect,
    int? energy,
    int? vitality,
    int? dayStreak,
    String? lastActiveDate,
    String? dailyQuestCompletedDate,
    int? lookIndex,
    int? backgroundTheme,
    int? xpEarnedToday,
    String? xpEarnedDate,
    List<String>? weeklyActiveDates,
    String? weeklyRewardWeekKey,
    Map<String, DayStat>? dailyStats,
    bool clearDailyQuest = false,
  }) {
    return Player(
      name: name ?? this.name,
      xp: xp ?? this.xp,
      strength: strength ?? this.strength,
      intellect: intellect ?? this.intellect,
      energy: energy ?? this.energy,
      vitality: vitality ?? this.vitality,
      dayStreak: dayStreak ?? this.dayStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      dailyQuestCompletedDate: clearDailyQuest
          ? null
          : (dailyQuestCompletedDate ?? this.dailyQuestCompletedDate),
      lookIndex: lookIndex ?? this.lookIndex,
      backgroundTheme: backgroundTheme ?? this.backgroundTheme,
      xpEarnedToday: xpEarnedToday ?? this.xpEarnedToday,
      xpEarnedDate: xpEarnedDate ?? this.xpEarnedDate,
      weeklyActiveDates: weeklyActiveDates ?? this.weeklyActiveDates,
      weeklyRewardWeekKey: weeklyRewardWeekKey ?? this.weeklyRewardWeekKey,
      dailyStats: dailyStats ?? this.dailyStats,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'xp': xp,
      'strength': strength,
      'intellect': intellect,
      'energy': energy,
      'vitality': vitality,
      'dayStreak': dayStreak,
      'lastActiveDate': lastActiveDate,
      'dailyQuestCompletedDate': dailyQuestCompletedDate,
      'lookIndex': lookIndex,
      'backgroundTheme': backgroundTheme,
      'xpEarnedToday': xpEarnedToday,
      'xpEarnedDate': xpEarnedDate,
      'weeklyActiveDates': weeklyActiveDates,
      'weeklyRewardWeekKey': weeklyRewardWeekKey,
      'dailyStats': dailyStats.map((k, v) => MapEntry(k, v.toJson())),
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    final rawDates = json['weeklyActiveDates'];
    final dates = rawDates is List
        ? rawDates.map((e) => e.toString()).toList()
        : <String>[];
    final rawStats = json['dailyStats'];
    final stats = <String, DayStat>{};
    if (rawStats is Map) {
      rawStats.forEach((k, v) {
        if (v is Map) {
          stats[k.toString()] =
              DayStat.fromJson(Map<String, dynamic>.from(v));
        }
      });
    }
    return Player(
      name: json['name'] as String? ?? 'Gezgin',
      xp: json['xp'] as int? ?? 0,
      strength: json['strength'] as int? ?? 1,
      intellect: json['intellect'] as int? ?? 1,
      energy: json['energy'] as int? ?? 1,
      vitality: json['vitality'] as int? ?? 1,
      dayStreak: json['dayStreak'] as int? ?? 0,
      lastActiveDate: json['lastActiveDate'] as String?,
      dailyQuestCompletedDate: json['dailyQuestCompletedDate'] as String?,
      lookIndex: json['lookIndex'] as int? ?? 0,
      backgroundTheme: json['backgroundTheme'] as int? ?? 0,
      xpEarnedToday: json['xpEarnedToday'] as int? ?? 0,
      xpEarnedDate: json['xpEarnedDate'] as String?,
      weeklyActiveDates: dates,
      weeklyRewardWeekKey: json['weeklyRewardWeekKey'] as String?,
      dailyStats: stats,
    );
  }
}

import 'package:flutter/material.dart';

enum AchievementKind {
  level,
  dayStreak,
  habitStreak,
  anyHabit,
  dailyQuest,
  weeklyChallenge,
  habitCount,
  unlockCount,
  xpTotal,
}

extension AchievementKindJson on AchievementKind {
  static AchievementKind fromKey(String key) {
    switch (key) {
      case 'level':
        return AchievementKind.level;
      case 'day_streak':
        return AchievementKind.dayStreak;
      case 'habit_streak':
        return AchievementKind.habitStreak;
      case 'any_habit':
        return AchievementKind.anyHabit;
      case 'daily_quest':
        return AchievementKind.dailyQuest;
      case 'weekly_challenge':
        return AchievementKind.weeklyChallenge;
      case 'habit_count':
        return AchievementKind.habitCount;
      case 'unlock_count':
        return AchievementKind.unlockCount;
      case 'xp_total':
        return AchievementKind.xpTotal;
      default:
        return AchievementKind.level;
    }
  }

  IconData get icon {
    switch (this) {
      case AchievementKind.level:
        return Icons.military_tech;
      case AchievementKind.dayStreak:
        return Icons.local_fire_department;
      case AchievementKind.habitStreak:
        return Icons.repeat;
      case AchievementKind.anyHabit:
        return Icons.check_circle;
      case AchievementKind.dailyQuest:
        return Icons.flag;
      case AchievementKind.weeklyChallenge:
        return Icons.calendar_month;
      case AchievementKind.habitCount:
        return Icons.playlist_add_check;
      case AchievementKind.unlockCount:
        return Icons.inventory_2;
      case AchievementKind.xpTotal:
        return Icons.bolt;
    }
  }
}

class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.target,
    this.bonusXp = 0,
  });

  final String id;
  final String title;
  final String description;
  final AchievementKind kind;
  final int target;
  final int bonusXp;

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      kind: AchievementKindJson.fromKey(json['kind'] as String),
      target: json['target'] as int? ?? 1,
      bonusXp: json['bonusXp'] as int? ?? 0,
    );
  }
}

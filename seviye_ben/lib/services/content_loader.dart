import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/achievement.dart';
import '../models/daily_quest.dart';
import '../models/equipment.dart';
import '../models/habit.dart';
import '../models/weekly_challenge.dart';
import '../utils/date_keys.dart';

class GameContent {
  const GameContent({
    required this.habits,
    required this.equipment,
    required this.levelMessages,
    required this.dailyQuests,
    required this.titles,
    required this.achievements,
    this.streetLines = const [],
    this.equipmentSets = const [],
    this.weeklyChallenges = const [],
  });

  final List<Habit> habits;
  final List<Equipment> equipment;
  final Map<String, String> levelMessages;
  final List<DailyQuest> dailyQuests;
  final List<LevelTitle> titles;
  final List<Achievement> achievements;
  final List<String> streetLines;
  final List<EquipmentSet> equipmentSets;
  final List<WeeklyChallenge> weeklyChallenges;

  Equipment? equipmentById(String id) {
    for (final e in equipment) {
      if (e.id == id) {
        return e;
      }
    }
    return null;
  }

  EquipmentSet? setById(String id) {
    for (final s in equipmentSets) {
      if (s.id == id) {
        return s;
      }
    }
    return null;
  }

  Achievement? achievementById(String id) {
    for (final a in achievements) {
      if (a.id == id) {
        return a;
      }
    }
    return null;
  }

  String? messageForLevel(int level) => levelMessages['$level'];

  DailyQuest todaysQuest([DateTime? now]) {
    if (dailyQuests.isEmpty) {
      return const DailyQuest(
        id: 'dq_fallback',
        title: 'Üçlü kombo',
        description: 'Bugün en az 3 rutin bitir.',
        targetCount: 3,
        bonusXp: 25,
      );
    }
    final index = dayOfYear(now) % dailyQuests.length;
    return dailyQuests[index];
  }

  String todaysStreetLine([DateTime? now]) {
    if (streetLines.isEmpty) {
      return 'Bugün de tempoyu tut.';
    }
    return streetLines[dayOfYear(now) % streetLines.length];
  }

  WeeklyChallenge thisWeeksChallenge([DateTime? now]) {
    if (weeklyChallenges.isEmpty) {
      return const WeeklyChallenge(
        id: 'wq_fallback',
        title: 'Yedi gün tempo',
        description: 'Bu hafta 7 gün en az bir rutin bitir.',
        targetDays: 7,
        bonusXp: 80,
      );
    }
    final index = weekIndex(now) % weeklyChallenges.length;
    return weeklyChallenges[index];
  }
}

class ContentLoader {
  ContentLoader._();

  static GameContent? _cache;

  static Future<GameContent> load() async {
    if (_cache != null) {
      return _cache!;
    }
    final raw = await rootBundle.loadString(
      'assets/content/seviye_ben_content.json',
    );
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final habits = (json['habits'] as List)
        .map((e) => Habit.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final equipment = (json['equipment'] as List)
        .map((e) => Equipment.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final messages = Map<String, String>.from(
      (json['level_messages'] as Map).map(
        (k, v) => MapEntry(k.toString(), v.toString()),
      ),
    );
    final dailyQuests = (json['daily_quests'] as List? ?? [])
        .map((e) => DailyQuest.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final titles = (json['titles'] as List? ?? [])
        .map((e) => LevelTitle.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final achievements = (json['achievements'] as List? ?? [])
        .map((e) => Achievement.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final streetLines = (json['street_lines'] as List? ?? [])
        .map((e) => e.toString())
        .toList();
    final equipmentSets = (json['equipment_sets'] as List? ?? [])
        .map(
          (e) => EquipmentSet.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
    final weeklyChallenges = (json['weekly_challenges'] as List? ?? [])
        .map(
          (e) =>
              WeeklyChallenge.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
    _cache = GameContent(
      habits: habits,
      equipment: equipment,
      levelMessages: messages,
      dailyQuests: dailyQuests,
      titles: titles,
      achievements: achievements,
      streetLines: streetLines,
      equipmentSets: equipmentSets,
      weeklyChallenges: weeklyChallenges,
    );
    return _cache!;
  }

  static GameContent get requireCache {
    final c = _cache;
    if (c == null) {
      throw StateError('ContentLoader.load() önce çağrılmalı');
    }
    return c;
  }
}

List<Habit> seedHabitsFromContent(GameContent content) {
  return content.habits
      .map(
        (h) => Habit(
          id: h.id,
          title: h.title,
          stat: h.stat,
          xpReward: h.xpReward,
        ),
      )
      .toList();
}

import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/achievement.dart';
import 'package:seviye_ben/models/daily_quest.dart';
import 'package:seviye_ben/models/equipment.dart';
import 'package:seviye_ben/models/habit.dart';
import 'package:seviye_ben/services/content_loader.dart';
import 'package:seviye_ben/utils/date_keys.dart';

void main() {
  const lines = [
    'A',
    'B',
    'C',
  ];

  GameContent content({List<String> street = lines}) {
    return GameContent(
      habits: const <Habit>[],
      equipment: const <Equipment>[],
      levelMessages: const {},
      dailyQuests: const <DailyQuest>[],
      titles: const <LevelTitle>[],
      achievements: const <Achievement>[],
      streetLines: street,
    );
  }

  test('todaysStreetLine gün indeksine göre seçer', () {
    final c = content();
    final day = DateTime(2026, 7, 23);
    final index = dayOfYear(day) % lines.length;
    expect(c.todaysStreetLine(day), lines[index]);
  });

  test('boş listede fallback', () {
    final c = content(street: const []);
    expect(c.todaysStreetLine(), 'Bugün de tempoyu tut.');
  });

  test('aynı gün aynı cümle', () {
    final c = content();
    final day = DateTime(2026, 1, 15, 8);
    final later = DateTime(2026, 1, 15, 22);
    expect(c.todaysStreetLine(day), c.todaysStreetLine(later));
  });
}

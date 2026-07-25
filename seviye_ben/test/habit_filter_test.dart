import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/habit.dart';
import 'package:seviye_ben/models/stat_type.dart';
import 'package:seviye_ben/utils/habit_filter.dart';

void main() {
  final habits = [
    Habit(id: 'a', title: 'A', stat: StatType.strength),
    Habit(id: 'b', title: 'B', stat: StatType.intellect),
    Habit(id: 'c', title: 'C', stat: StatType.strength),
    Habit(id: 'd', title: 'D', stat: StatType.vitality),
  ];

  test('null filtre tümünü döner', () {
    expect(filterHabitsByStat(habits, null), hasLength(4));
  });

  test('güç filtresi', () {
    final filtered = filterHabitsByStat(habits, StatType.strength);
    expect(filtered.map((h) => h.id), ['a', 'c']);
  });

  test('boş kategori', () {
    expect(filterHabitsByStat(habits, StatType.energy), isEmpty);
  });
}

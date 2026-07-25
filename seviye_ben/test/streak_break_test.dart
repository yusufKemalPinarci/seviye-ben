import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/habit.dart';
import 'package:seviye_ben/models/stat_type.dart';
import 'package:seviye_ben/utils/streak_break.dart';

void main() {
  Habit habit({
    int streak = 5,
    String? lastCompletedDate,
  }) {
    return Habit(
      id: 'h1',
      title: 'Yürü',
      stat: StatType.strength,
      streak: streak,
      lastCompletedDate: lastCompletedDate,
    );
  }

  final now = DateTime(2026, 7, 23);

  test('dün bitmişse kırılmamış', () {
    expect(
      isHabitStreakBroken(habit(lastCompletedDate: '2026-07-22'), now),
      isFalse,
    );
  });

  test('bugün bitmişse kırılmamış', () {
    expect(
      isHabitStreakBroken(habit(lastCompletedDate: '2026-07-23'), now),
      isFalse,
    );
  });

  test('iki günden eskiyse kırılmış', () {
    expect(
      isHabitStreakBroken(habit(lastCompletedDate: '2026-07-20'), now),
      isTrue,
    );
  });

  test('seri 1 ise uyarı yok', () {
    expect(
      isHabitStreakBroken(
        habit(streak: 1, lastCompletedDate: '2026-07-20'),
        now,
      ),
      isFalse,
    );
  });

  test('findBrokenStreaks sadece kırıkları döner', () {
    final list = findBrokenStreaks(
      [
        habit(lastCompletedDate: '2026-07-20'),
        habit(streak: 3, lastCompletedDate: '2026-07-22'),
      ],
      now,
    );
    expect(list, hasLength(1));
    expect(list.first.lostStreak, 5);
  });
}

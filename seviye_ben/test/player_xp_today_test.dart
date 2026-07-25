import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/player.dart';

void main() {
  test('creditXp aynı günde birikir', () {
    final p = Player().creditXp(10, '2026-07-23').creditXp(5, '2026-07-23');
    expect(p.xp, 15);
    expect(p.xpEarnedOn('2026-07-23'), 15);
    expect(p.dailyStats['2026-07-23']?.xp, 15);
  });

  test('creditXp yeni günde sıfırdan başlar', () {
    final p = Player(xp: 40, xpEarnedToday: 40, xpEarnedDate: '2026-07-22')
        .creditXp(12, '2026-07-23');
    expect(p.xp, 52);
    expect(p.xpEarnedOn('2026-07-23'), 12);
    expect(p.xpEarnedOn('2026-07-22'), 0);
  });

  test('xpEarnedOn tarih uyuşmazsa 0', () {
    final p = Player(xpEarnedToday: 99, xpEarnedDate: '2026-01-01');
    expect(p.xpEarnedOn('2026-07-23'), 0);
  });

  test('recordHabitDone habits artırır', () {
    final p = Player().recordHabitDone('2026-07-23').recordHabitDone('2026-07-23');
    expect(p.dailyStats['2026-07-23']?.habits, 2);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/utils/date_keys.dart';

void main() {
  test('weekStartKey Pazartesi', () {
    // 2026-07-23 Perşembe → Pazartesi 2026-07-20
    expect(weekStartKey(DateTime(2026, 7, 23)), '2026-07-20');
    expect(weekStartKey(DateTime(2026, 7, 20)), '2026-07-20');
  });

  test('datesInWeek filtreler', () {
    final week = '2026-07-20';
    final dates = [
      '2026-07-19',
      '2026-07-20',
      '2026-07-23',
      '2026-07-26',
      '2026-07-27',
    ];
    expect(datesInWeek(dates, week), ['2026-07-20', '2026-07-23', '2026-07-26']);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/player.dart';
import 'package:seviye_ben/utils/week_stats.dart';

void main() {
  test('lastNDayStats 7 nokta üretir', () {
    final points = lastNDayStats(
      {
        '2026-07-23': const DayStat(xp: 40, habits: 2),
      },
      now: DateTime(2026, 7, 23),
    );
    expect(points, hasLength(7));
    expect(points.last.dateKey, '2026-07-23');
    expect(points.last.stat.xp, 40);
    expect(points.first.dateKey, '2026-07-17');
    expect(points.first.label, 'Cum');
  });
}

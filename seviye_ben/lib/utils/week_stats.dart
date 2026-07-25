import '../models/player.dart';
import 'date_keys.dart';

class DayChartPoint {
  const DayChartPoint({
    required this.dateKey,
    required this.label,
    required this.stat,
  });

  final String dateKey;
  final String label;
  final DayStat stat;
}

const _weekdayShort = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

/// Bugünden geriye [days] gün (eski → yeni).
List<DayChartPoint> lastNDayStats(
  Map<String, DayStat> stats, {
  DateTime? now,
  int days = 7,
}) {
  final end = now ?? DateTime.now();
  final points = <DayChartPoint>[];
  for (var i = days - 1; i >= 0; i--) {
    final d = DateTime(end.year, end.month, end.day)
        .subtract(Duration(days: i));
    final key = todayKey(d);
    points.add(
      DayChartPoint(
        dateKey: key,
        label: _weekdayShort[d.weekday - 1],
        stat: stats[key] ?? const DayStat(),
      ),
    );
  }
  return points;
}

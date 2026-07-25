import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/player.dart';
import 'package:seviye_ben/utils/app_theme.dart';
import 'package:seviye_ben/utils/week_stats.dart';
import 'package:seviye_ben/views/widgets/week_stats_chart.dart';

void main() {
  testWidgets('WeekStatsChart başlık gösterir', (tester) async {
    final points = lastNDayStats(
      {'2026-07-23': const DayStat(xp: 20, habits: 1)},
      now: DateTime(2026, 7, 23),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: WeekStatsChart(points: points)),
      ),
    );
    expect(find.text('Son 7 gün'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
  });
}

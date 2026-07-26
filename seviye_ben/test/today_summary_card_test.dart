import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/utils/app_theme.dart';
import 'package:seviye_ben/views/widgets/today_summary_card.dart';

void main() {
  testWidgets('TodaySummaryCard rutin ve XP gösterir', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: TodaySummaryCard(routinesDone: 3, xpEarned: 42),
        ),
      ),
    );
    expect(find.text('Bugün özeti'), findsOneWidget);
    expect(find.text('3 rutin bitti'), findsOneWidget);
    expect(find.text('+42'), findsOneWidget);
    expect(find.text('XP'), findsOneWidget);
  });

  testWidgets('boş günde ipucu gösterir', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: TodaySummaryCard(routinesDone: 0, xpEarned: 0),
        ),
      ),
    );
    expect(find.text('Henüz rutin yok'), findsOneWidget);
    expect(find.textContaining('İlk rutini bitir'), findsOneWidget);
  });
}

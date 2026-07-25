import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/utils/app_theme.dart';
import 'package:seviye_ben/utils/streak_break.dart';
import 'package:seviye_ben/views/widgets/streak_break_banner.dart';

void main() {
  testWidgets('StreakBreakBanner tek rutin metni', (tester) async {
    var dismissed = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: StreakBreakBanner(
            breaks: const [
              StreakBreakInfo(habitTitle: 'Yürü', lostStreak: 4),
            ],
            onDismiss: () => dismissed = true,
          ),
        ),
      ),
    );
    expect(find.text('Seri ara verdi'), findsOneWidget);
    expect(find.textContaining('Yürü'), findsOneWidget);
    await tester.tap(find.text('Anladım'));
    expect(dismissed, isTrue);
  });
}

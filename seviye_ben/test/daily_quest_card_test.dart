import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/daily_quest.dart';
import 'package:seviye_ben/utils/app_theme.dart';
import 'package:seviye_ben/views/widgets/daily_quest_card.dart';

void main() {
  const quest = DailyQuest(
    id: 'dq_test',
    title: 'Üçlü kombo',
    description: 'Bugün en az 3 rutin bitir.',
    targetCount: 3,
    bonusXp: 25,
  );

  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );
  }

  testWidgets('ilerleme ve ödül metni görünür', (tester) async {
    await tester.pumpWidget(
      wrap(
        const DailyQuestCard(
          quest: quest,
          progress: 1,
          done: false,
          dayStreak: 3,
        ),
      ),
    );

    expect(find.text('Günlük görev'), findsOneWidget);
    expect(find.text('Üçlü kombo'), findsOneWidget);
    expect(find.text('Bugün en az 3 rutin bitir.'), findsOneWidget);
    expect(find.text('1 / 3 · ödül +25 XP'), findsOneWidget);
    expect(find.text('Seri 3 gün'), findsOneWidget);
  });

  testWidgets('tamamlanınca ödül alındı metni', (tester) async {
    await tester.pumpWidget(
      wrap(
        const DailyQuestCard(
          quest: quest,
          progress: 3,
          done: true,
          dayStreak: 0,
        ),
      ),
    );

    expect(find.text('Günlük görev tamam'), findsOneWidget);
    expect(find.text('+25 XP alındı'), findsOneWidget);
    expect(find.textContaining('Seri'), findsNothing);
  });
}

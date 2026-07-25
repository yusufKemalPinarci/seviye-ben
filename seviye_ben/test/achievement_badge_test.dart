import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/achievement.dart';
import 'package:seviye_ben/utils/app_theme.dart';
import 'package:seviye_ben/views/widgets/achievement_badge_row.dart';

void main() {
  test('yeni kind’ler parse edilir', () {
    expect(
      AchievementKindJson.fromKey('weekly_challenge'),
      AchievementKind.weeklyChallenge,
    );
    expect(
      AchievementKindJson.fromKey('xp_total'),
      AchievementKind.xpTotal,
    );
  });

  testWidgets('rozet şeridi açılmış başarımları gösterir', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AchievementBadgeRow(
            unlocked: const [
              Achievement(
                id: 'a1',
                title: 'İlk ritim',
                description: 'x',
                kind: AchievementKind.anyHabit,
                target: 1,
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.text('İlk ritim'), findsOneWidget);
  });

  testWidgets('boş rozet mesajı', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: AchievementBadgeRow(unlocked: []),
        ),
      ),
    );
    expect(find.textContaining('Henüz rozet yok'), findsOneWidget);
  });
}

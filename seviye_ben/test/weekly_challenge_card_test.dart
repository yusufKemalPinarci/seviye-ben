import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/weekly_challenge.dart';
import 'package:seviye_ben/utils/app_theme.dart';
import 'package:seviye_ben/views/widgets/weekly_challenge_card.dart';

void main() {
  testWidgets('WeeklyChallengeCard ilerleme gösterir', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: WeeklyChallengeCard(
            challenge: WeeklyChallenge(
              id: 'wq',
              title: 'Yedi gün tempo',
              description: '7 gün aktif.',
              targetDays: 7,
              bonusXp: 80,
            ),
            progressDays: 3,
            done: false,
          ),
        ),
      ),
    );
    expect(find.text('Haftalık meydan'), findsOneWidget);
    expect(find.text('3/7'), findsOneWidget);
    expect(find.textContaining('ödül +80 XP'), findsOneWidget);
  });
}

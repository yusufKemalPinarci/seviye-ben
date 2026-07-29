import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/utils/app_theme.dart';
import 'package:seviye_ben/views/screens/onboarding_screen.dart';

void main() {
  testWidgets('onboarding loop adımı Bitir→XP→Giy gösterir', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: OnboardingScreen(onFinished: () {}),
        ),
      ),
    );

    expect(find.text('SeviyeBen'), findsOneWidget);
    await tester.tap(find.text('Nasıl çalışır?'));
    await tester.pumpAndSettle();

    expect(find.text('Sokak döngüsü'), findsOneWidget);
    expect(find.text('Bitir'), findsOneWidget);
    expect(find.text('XP ve seviye'), findsOneWidget);
    expect(find.text('Giy ve güçlen'), findsOneWidget);

    await tester.tap(find.text('Anladım'));
    await tester.pumpAndSettle();
    expect(find.text('Sana ne diyelim?'), findsOneWidget);
  });
}

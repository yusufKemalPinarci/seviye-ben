import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/utils/app_theme.dart';
import 'package:seviye_ben/views/widgets/street_line_card.dart';

void main() {
  testWidgets('StreetLineCard etiket ve cümle gösterir', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: StreetLineCard(line: 'Asfalt ısındı.'),
        ),
      ),
    );
    expect(find.text('Sokak notu'), findsOneWidget);
    expect(find.text('Asfalt ısındı.'), findsOneWidget);
  });
}

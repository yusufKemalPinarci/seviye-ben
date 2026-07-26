import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/equipment.dart';
import 'package:seviye_ben/utils/app_theme.dart';
import 'package:seviye_ben/views/widgets/level_up_celebration.dart';

void main() {
  testWidgets('LevelUpCelebration metin ve avatar gösterir', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: LevelUpCelebration(
            level: 5,
            lookIndex: 0,
            equipped: {
              EquipSlot.head: null,
              EquipSlot.body: null,
              EquipSlot.back: null,
              EquipSlot.feet: null,
              EquipSlot.accessory: null,
            },
            message: 'Rutinin oturuyor.',
            unlockNames: ['Bere'],
          ),
        ),
      ),
    );

    expect(find.text('Seviye atladın!'), findsOneWidget);
    expect(find.text('Seviye 5'), findsOneWidget);
    expect(find.text('Rutinin oturuyor.'), findsOneWidget);
    expect(find.textContaining('Yeni açılan'), findsOneWidget);
    expect(find.text('Devam'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 100));
  });
}

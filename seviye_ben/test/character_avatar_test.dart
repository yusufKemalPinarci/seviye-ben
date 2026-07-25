import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/equipment.dart';
import 'package:seviye_ben/utils/app_theme.dart';
import 'package:seviye_ben/views/widgets/character_avatar.dart';

void main() {
  testWidgets('CharacterAvatar çizilir', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: Center(
            child: CharacterAvatar(
              lookIndex: 0,
              level: 3,
              equipped: {
                EquipSlot.head: null,
                EquipSlot.body: null,
                EquipSlot.feet: null,
                EquipSlot.accessory: null,
              },
              size: 120,
            ),
          ),
        ),
      ),
    );
    expect(find.byType(CharacterAvatar), findsOneWidget);
  });
}

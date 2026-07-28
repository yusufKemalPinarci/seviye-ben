import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/equipment.dart';
import 'package:seviye_ben/utils/app_theme.dart';
import 'package:seviye_ben/views/widgets/animated_character_avatar.dart';
import 'package:seviye_ben/views/widgets/character_avatar.dart';

Map<EquipSlot, Equipment?> get _emptyEquipped => {
      EquipSlot.head: null,
      EquipSlot.body: null,
      EquipSlot.back: null,
      EquipSlot.feet: null,
      EquipSlot.accessory: null,
    };

void main() {
  testWidgets('AnimatedCharacterAvatar çizilir', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Center(
            child: AnimatedCharacterAvatar(
              lookIndex: 0,
              level: 3,
              equipped: _emptyEquipped,
              size: 120,
            ),
          ),
        ),
      ),
    );
    expect(find.byType(AnimatedCharacterAvatar), findsOneWidget);
    expect(find.byType(CharacterAvatar), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('habitCompletePulse artınca bounce controller ilerler',
      (tester) async {
    var pulse = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Center(
            child: AnimatedCharacterAvatar(
              lookIndex: 0,
              level: 2,
              equipped: _emptyEquipped,
              size: 88,
              habitCompletePulse: pulse,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    pulse = 1;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Center(
            child: AnimatedCharacterAvatar(
              lookIndex: 0,
              level: 2,
              equipped: _emptyEquipped,
              size: 88,
              habitCompletePulse: pulse,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(AnimatedCharacterAvatar), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('reduce-motion ile animasyon kapalı kalır', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: AnimatedCharacterAvatar(
                lookIndex: 1,
                level: 1,
                equipped: _emptyEquipped,
                size: 100,
                habitCompletePulse: 0,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: AnimatedCharacterAvatar(
                lookIndex: 1,
                level: 1,
                equipped: _emptyEquipped,
                size: 100,
                habitCompletePulse: 2,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(CharacterAvatar), findsOneWidget);
  });
}

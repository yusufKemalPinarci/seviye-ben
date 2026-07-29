import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/equipment.dart';
import 'package:seviye_ben/utils/app_theme.dart';
import 'package:seviye_ben/utils/equipment_look.dart';
import 'package:seviye_ben/views/widgets/character_avatar.dart';

void main() {
  const empty = {
    EquipSlot.head: null,
    EquipSlot.body: null,
    EquipSlot.back: null,
    EquipSlot.feet: null,
    EquipSlot.accessory: null,
  };

  testWidgets('CharacterAvatar çizilir', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: Center(
            child: CharacterAvatar(
              lookIndex: 0,
              level: 3,
              equipped: empty,
              size: 120,
            ),
          ),
        ),
      ),
    );
    expect(find.byType(CharacterAvatar), findsOneWidget);
  });

  test('AvatarPainter shouldRepaint seviye ve stat ile', () {
    final look = lookStyleFor(0);
    final a = AvatarPainter(
      look: look,
      level: 3,
      equipped: empty,
      strength: 1,
      intellect: 1,
      energy: 1,
      vitality: 1,
      showLevelBadge: true,
      showStatAura: true,
    );
    final b = AvatarPainter(
      look: look,
      level: 15,
      equipped: empty,
      strength: 1,
      intellect: 1,
      energy: 1,
      vitality: 1,
      showLevelBadge: true,
      showStatAura: true,
    );
    final c = AvatarPainter(
      look: look,
      level: 3,
      equipped: empty,
      strength: 9,
      intellect: 1,
      energy: 1,
      vitality: 1,
      showLevelBadge: true,
      showStatAura: true,
    );
    expect(a.shouldRepaint(b), isTrue);
    expect(a.shouldRepaint(c), isTrue);
    expect(a.shouldRepaint(a), isFalse);
  });
}

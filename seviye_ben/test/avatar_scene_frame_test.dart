import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/utils/app_theme.dart';
import 'package:seviye_ben/utils/background_theme.dart';
import 'package:seviye_ben/views/widgets/avatar_scene_frame.dart';

void main() {
  testWidgets('AvatarSceneFrame üç tema ile çizilir', (tester) async {
    for (final scene in sceneBackgrounds) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: AvatarSceneFrame(
                  themeIndex: scene.id,
                  child: const Text('avatar'),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(AvatarSceneFrame), findsOneWidget);
      expect(find.text('avatar'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    }
  });
}

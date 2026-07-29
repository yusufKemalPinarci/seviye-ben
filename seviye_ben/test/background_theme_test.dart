import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/player.dart';
import 'package:seviye_ben/utils/background_theme.dart';

void main() {
  test('beş sahne teması tanımlı', () {
    expect(sceneBackgrounds, hasLength(5));
    expect(backgroundThemeFor(0).key, 'street');
    expect(backgroundThemeFor(1).key, 'night');
    expect(backgroundThemeFor(2).key, 'rain');
    expect(backgroundThemeFor(3).key, 'dusk');
    expect(backgroundThemeFor(4).key, 'neon');
    expect(backgroundThemeFor(99).id, 0);
  });

  test('clampBackgroundTheme sınırlar', () {
    expect(clampBackgroundTheme(-1), 0);
    expect(clampBackgroundTheme(2), 2);
    expect(clampBackgroundTheme(4), 4);
    expect(clampBackgroundTheme(5), 0);
  });

  test('sahne kilitleri seviye/seri ile', () {
    expect(
      isSceneUnlocked(sceneBackgrounds[0], level: 1, dayStreak: 0),
      isTrue,
    );
    expect(
      isSceneUnlocked(sceneBackgrounds[1], level: 4, dayStreak: 0),
      isFalse,
    );
    expect(
      isSceneUnlocked(sceneBackgrounds[1], level: 5, dayStreak: 0),
      isTrue,
    );
    expect(
      isSceneUnlocked(sceneBackgrounds[4], level: 15, dayStreak: 2),
      isFalse,
    );
    expect(
      isSceneUnlocked(sceneBackgrounds[4], level: 15, dayStreak: 3),
      isTrue,
    );
  });

  test('resolveUsableBackgroundTheme kilitliyse düşer', () {
    expect(
      resolveUsableBackgroundTheme(
        themeIndex: 4,
        level: 1,
        dayStreak: 0,
      ),
      0,
    );
    expect(
      resolveUsableBackgroundTheme(
        themeIndex: 1,
        level: 5,
        dayStreak: 0,
      ),
      1,
    );
  });

  test('Player backgroundTheme JSON round-trip', () {
    final p = Player(backgroundTheme: 2);
    final restored = Player.fromJson(p.toJson());
    expect(restored.backgroundTheme, 2);
  });

  test('eski kayıtta backgroundTheme yoksa 0', () {
    final p = Player.fromJson({'name': 'Gezgin', 'xp': 0});
    expect(p.backgroundTheme, 0);
  });
}

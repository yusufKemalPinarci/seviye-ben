import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/player.dart';
import 'package:seviye_ben/utils/background_theme.dart';

void main() {
  test('üç sahne teması tanımlı', () {
    expect(sceneBackgrounds, hasLength(3));
    expect(backgroundThemeFor(0).key, 'street');
    expect(backgroundThemeFor(1).key, 'night');
    expect(backgroundThemeFor(2).key, 'rain');
    expect(backgroundThemeFor(99).id, 0);
  });

  test('clampBackgroundTheme sınırlar', () {
    expect(clampBackgroundTheme(-1), 0);
    expect(clampBackgroundTheme(2), 2);
    expect(clampBackgroundTheme(5), 0);
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

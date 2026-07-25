import 'package:audioplayers/audioplayers.dart';

/// Yerel SFX; ağ kullanmaz. Kapalıyken veya hata olunca sessizce geçer.
class SoundService {
  SoundService._();

  static AudioPlayer? _player;
  static bool enabled = true;

  static Future<void> playHabitDone() => _play('sfx/habit_done.wav');

  static Future<void> playLevelUp() => _play('sfx/level_up.wav');

  static Future<void> _play(String assetPath) async {
    if (!enabled) {
      return;
    }
    try {
      _player ??= AudioPlayer();
      await _player!.stop();
      await _player!.play(AssetSource(assetPath));
    } catch (_) {}
  }
}

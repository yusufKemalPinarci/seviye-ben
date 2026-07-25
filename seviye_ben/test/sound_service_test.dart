import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/services/sound_service.dart';

void main() {
  test('kapalıyken play no-op (hata fırlatmaz)', () async {
    SoundService.enabled = false;
    await SoundService.playHabitDone();
    await SoundService.playLevelUp();
    SoundService.enabled = true;
  });
}

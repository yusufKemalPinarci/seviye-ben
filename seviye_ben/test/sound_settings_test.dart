import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:seviye_ben/services/local_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('seviye_ben_sound_');
    Hive.init(tempDir.path);
    await LocalStore.init();
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('ses varsayılan açık', () {
    expect(LocalStore.isSoundEnabled(), isTrue);
  });

  test('ses kapatılıp açılır', () async {
    await LocalStore.setSoundEnabled(false);
    expect(LocalStore.isSoundEnabled(), isFalse);
    await LocalStore.setSoundEnabled(true);
    expect(LocalStore.isSoundEnabled(), isTrue);
  });
}

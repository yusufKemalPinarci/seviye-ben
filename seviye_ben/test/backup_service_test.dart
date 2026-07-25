import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:seviye_ben/models/player.dart';
import 'package:seviye_ben/services/backup_service.dart';
import 'package:seviye_ben/services/content_loader.dart';
import 'package:seviye_ben/services/local_store.dart';
import 'package:seviye_ben/services/sound_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late GameContent content;

  setUpAll(() async {
    SoundService.enabled = false;
    tempDir = await Directory.systemTemp.createTemp('seviye_ben_bak_');
    Hive.init(tempDir.path);
    await LocalStore.init();
    content = ContentLoader.requireCache;
  });

  tearDown(() async {
    await Hive.box('player').clear();
    await Hive.box('habits').clear();
    await Hive.box('inventory').clear();
    await Hive.box('settings').clear();
    await LocalStore.init();
  });

  tearDownAll(() async {
    try {
      await Hive.close().timeout(const Duration(seconds: 2));
    } catch (_) {}
    if (tempDir.existsSync()) {
      try {
        await tempDir.delete(recursive: true);
      } catch (_) {}
    }
  });

  test('encode + parse round-trip', () async {
    await LocalStore.savePlayer(Player(name: 'Yedekçi', xp: 42));
    final json = BackupService.encodeSnapshot(exportedAt: DateTime(2026, 7, 24));
    expect(json, contains('"appId": "seviye_ben"'));
    expect(json, contains('"schemaVersion": 1'));

    final data = BackupService.parseAndValidate(json, content: content);
    expect(data['player'], isA<Map>());
    final player = Player.fromJson(
      Map<String, dynamic>.from(data['player'] as Map),
    );
    expect(player.name, 'Yedekçi');
    expect(player.xp, 42);
  });

  test('applyToHive geri yükler', () async {
    await LocalStore.savePlayer(Player(name: 'Asıl', xp: 10));
    final json = BackupService.encodeSnapshot();
    await LocalStore.savePlayer(Player(name: 'Değişti', xp: 999));
    expect(LocalStore.loadPlayer().name, 'Değişti');

    final data = BackupService.parseAndValidate(json, content: content);
    await BackupService.applyToHive(data);
    expect(LocalStore.loadPlayer().name, 'Asıl');
    expect(LocalStore.loadPlayer().xp, 10);
  });

  test('yanlış appId reddedilir', () {
    expect(
      () => BackupService.parseAndValidate(
        '{"schemaVersion":1,"appId":"habitica","data":{}}',
        content: content,
      ),
      throwsA(isA<BackupException>()),
    );
  });

  test('yeni şema tooNew', () {
    expect(
      () => BackupService.parseAndValidate(
        '''
{
  "schemaVersion": 99,
  "appId": "seviye_ben",
  "data": {
    "player": {},
    "habits": [],
    "inventory": {"unlocked": [], "equipped": {}},
    "settings": {}
  }
}
''',
        content: content,
      ),
      throwsA(
        predicate((e) => e is BackupException && e.message == 'tooNew'),
      ),
    );
  });

  test('bilinmeyen ekipman filtrelenir', () {
    final json = '''
{
  "schemaVersion": 1,
  "appId": "seviye_ben",
  "data": {
    "player": {"name": "Gezgin", "xp": 0},
    "habits": [],
    "inventory": {
      "unlocked": ["eq_bere", "eq_fake"],
      "equipped": {"head": "eq_bere", "body": "eq_fake"}
    },
    "settings": {"onboardingDone": true, "soundEnabled": true, "achievementIds": []}
  }
}
''';
    final data = BackupService.parseAndValidate(json, content: content);
    final inv = data['inventory'] as Map;
    expect(inv['unlocked'], ['eq_bere']);
    expect(inv['equipped'], {'head': 'eq_bere'});
  });

  test('hapticEnabled yedekte round-trip', () async {
    await LocalStore.setHapticEnabled(false);
    final json = BackupService.encodeSnapshot();
    await LocalStore.setHapticEnabled(true);
    expect(LocalStore.isHapticEnabled(), isTrue);

    final data = BackupService.parseAndValidate(json, content: content);
    await BackupService.applyToHive(data);
    expect(LocalStore.isHapticEnabled(), isFalse);
  });

  test('suggestFileName tarih içerir', () {
    expect(
      BackupService.suggestFileName(DateTime(2026, 7, 24)),
      'seviyeben_yedek_2026-07-24.json',
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/services/content_loader.dart';
import 'package:seviye_ben/utils/titles.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GameContent content;

  setUpAll(() async {
    content = await ContentLoader.load();
  });

  test('en az 13 ünvan basamağı, minLevel artan', () {
    expect(content.titles.length, greaterThanOrEqualTo(13));
    final levels = content.titles.map((t) => t.minLevel).toList();
    expect(levels.toSet().length, levels.length);
    for (var i = 1; i < levels.length; i++) {
      expect(levels[i], greaterThan(levels[i - 1]));
    }
  });

  test('en az 12 seviye mesajı; mevcut milestonelar korunur', () {
    expect(content.levelMessages.length, greaterThanOrEqualTo(12));
    expect(content.messageForLevel(2), isNotNull);
    expect(content.messageForLevel(5), isNotNull);
    expect(content.messageForLevel(10), isNotNull);
    expect(content.messageForLevel(20), isNotNull);
    expect(content.messageForLevel(12), contains('kaptan'));
    expect(content.messageForLevel(4), isNull);
  });

  test('titleForLevel eşikleri', () {
    final t = content.titles;
    expect(titleForLevel(1, t), 'Çaylak Gezgin');
    expect(titleForLevel(3, t), 'Sokak Çırağı');
    expect(titleForLevel(11, t), 'Mahalle Efsanesi');
    expect(titleForLevel(12, t), 'Asfalt Kaptanı');
    expect(titleForLevel(14, t), 'Asfalt Kaptanı');
    expect(titleForLevel(15, t), 'Seviye Efsanesi');
    expect(titleForLevel(30, t), 'Sokak Efsanesi');
  });
}

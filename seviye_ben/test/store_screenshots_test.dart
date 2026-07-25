import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Gerçek cihaz / emülatör görüntüsü için:
/// `STORE_SHOTS=1 flutter test test/store_screenshots_test.dart --update-goldens`
///
/// Varsayılan CI’da atlanır. Mağaza için hazır JPEG’ler:
/// `docs/store/screenshots/*.jpg` (`render_shots.py`).
void main() {
  test('store screenshots JPEG mevcut', () {
    final dir = Directory(
      '${Directory.current.path}${Platform.pathSeparator}..'
      '${Platform.pathSeparator}docs${Platform.pathSeparator}store'
      '${Platform.pathSeparator}screenshots',
    );
    final jpgs = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.jpg'))
        .toList();
    expect(jpgs.length, greaterThanOrEqualTo(2));
  });
}

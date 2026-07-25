import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/utils/app_theme.dart';
import 'package:seviye_ben/utils/settings_strings.dart';
import 'package:seviye_ben/utils/text_scale.dart';

void main() {
  test('TextScalePolicy 2.0’ı 1.5’e sıkıştırır', () {
    final clamped = TextScalePolicy.clampScaler(const TextScaler.linear(2.0));
    expect(clamped.scale(10), 15);
    expect(TextScalePolicy.maxScale, 1.5);
  });

  test('TextScalePolicy 1.2’yi korur', () {
    final clamped = TextScalePolicy.clampScaler(const TextScaler.linear(1.2));
    expect(clamped.scale(10), closeTo(12, 0.001));
  });

  test('onSurfaceMuted asphalt üzerinde tanımlı', () {
    final scheme = AppTheme.light.colorScheme;
    expect(scheme.onSurfaceVariant, AppTheme.onSurfaceMuted);
    expect(AppTheme.onSurfaceMuted, isNot(AppTheme.ink));
  });

  testWidgets('MaterialApp builder textScaler clamp uygular', (tester) async {
    late TextScaler seen;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.5)),
        child: MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) {
            final media = MediaQuery.of(context);
            return MediaQuery(
              data: media.copyWith(
                textScaler: TextScalePolicy.clampScaler(media.textScaler),
              ),
              child: Builder(
                builder: (context) {
                  seen = MediaQuery.textScalerOf(context);
                  return child ?? const SizedBox.shrink();
                },
              ),
            );
          },
          home: const Scaffold(body: Text('ok')),
        ),
      ),
    );
    expect(seen.scale(10), 15);
  });

  test('erişilebilirlik metinleri tanımlı', () {
    expect(SettingsStrings.sectionAccessibility, isNotEmpty);
    expect(SettingsStrings.fontScaleInfoBody, contains('sistem'));
  });
}

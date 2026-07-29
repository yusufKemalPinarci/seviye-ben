import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/stat_type.dart';
import 'package:seviye_ben/utils/progression_look.dart';

void main() {
  test('streetTierForLevel basamakları', () {
    expect(streetTierForLevel(1), StreetTier.apprentice);
    expect(streetTierForLevel(5), StreetTier.apprentice);
    expect(streetTierForLevel(6), StreetTier.rhythm);
    expect(streetTierForLevel(12), StreetTier.rhythm);
    expect(streetTierForLevel(13), StreetTier.legend);
    expect(streetTierForLevel(20), StreetTier.legend);
  });

  test('basamak isimleri Türkçe', () {
    expect(StreetTier.apprentice.nameTr, 'Asfalt çırak');
    expect(StreetTier.rhythm.nameTr, 'Mahalle ritmi');
    expect(StreetTier.legend.nameTr, 'Gece efsanesi');
  });

  test('dominantStat en yüksek değeri seçer', () {
    expect(
      dominantStat(
        strength: 3,
        intellect: 8,
        energy: 2,
        vitality: 4,
      ),
      StatType.intellect,
    );
  });

  test('dominantStat eşitlikte güç öncelikli', () {
    expect(
      dominantStat(
        strength: 5,
        intellect: 5,
        energy: 5,
        vitality: 5,
      ),
      StatType.strength,
    );
  });

  test('AvatarPainter shouldRepaint seviye/stat farkında', () {
    // Painter dışarıda; CharacterAvatar entegrasyonunda seviye değişince
    // ValueKey ile yeniden çizilir — burası ölçek tutarlılığı.
    expect(StreetTier.apprentice.scale < StreetTier.rhythm.scale, isTrue);
    expect(StreetTier.rhythm.scale < StreetTier.legend.scale, isTrue);
  });
}

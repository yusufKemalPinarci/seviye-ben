import 'package:flutter/material.dart';

import '../models/stat_type.dart';
import 'app_theme.dart';

/// Sokak kimliği basamağı — seviye ile avatar silueti değişir.
enum StreetTier { apprentice, rhythm, legend }

StreetTier streetTierForLevel(int level) {
  if (level >= 13) {
    return StreetTier.legend;
  }
  if (level >= 6) {
    return StreetTier.rhythm;
  }
  return StreetTier.apprentice;
}

extension StreetTierLabel on StreetTier {
  String get nameTr {
    switch (this) {
      case StreetTier.apprentice:
        return 'Asfalt çırak';
      case StreetTier.rhythm:
        return 'Mahalle ritmi';
      case StreetTier.legend:
        return 'Gece efsanesi';
    }
  }

  /// Siluet boy çarpanı (ayaklar sabit kalacak şekilde).
  double get scale {
    switch (this) {
      case StreetTier.apprentice:
        return 0.94;
      case StreetTier.rhythm:
        return 1.0;
      case StreetTier.legend:
        return 1.06;
    }
  }

  /// Omuz genişliği ek payı (0–1, `s` ile çarpılır).
  double get shoulderExtra {
    switch (this) {
      case StreetTier.apprentice:
        return 0.0;
      case StreetTier.rhythm:
        return 0.012;
      case StreetTier.legend:
        return 0.024;
    }
  }

  Color get ringColor {
    switch (this) {
      case StreetTier.apprentice:
        return AppTheme.streetMid;
      case StreetTier.rhythm:
        return AppTheme.signal;
      case StreetTier.legend:
        return AppTheme.xpGold;
    }
  }
}

/// En yüksek taban istatistik; eşitlikte güç → zeka → enerji → can.
StatType dominantStat({
  required int strength,
  required int intellect,
  required int energy,
  required int vitality,
}) {
  final entries = <(StatType, int)>[
    (StatType.strength, strength),
    (StatType.intellect, intellect),
    (StatType.energy, energy),
    (StatType.vitality, vitality),
  ];
  var best = entries.first;
  for (final e in entries.skip(1)) {
    if (e.$2 > best.$2) {
      best = e;
    }
  }
  return best.$1;
}

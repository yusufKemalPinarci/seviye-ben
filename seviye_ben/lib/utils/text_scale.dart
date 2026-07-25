import 'package:flutter/material.dart';

/// Sistem yazı ölçeği üst sınırı (layout güvenliği).
abstract final class TextScalePolicy {
  static const double maxScale = 1.5;

  static TextScaler clampScaler(TextScaler system) {
    return system.clamp(minScaleFactor: 0.01, maxScaleFactor: maxScale);
  }
}

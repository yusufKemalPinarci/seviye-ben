import 'package:flutter/services.dart';

/// Titreşim; kapalıyken sessizce geçer (SoundService ile aynı model).
class HapticService {
  HapticService._();

  static bool enabled = true;

  static Future<void> lightImpact() async {
    if (!enabled) {
      return;
    }
    await HapticFeedback.lightImpact();
  }

  static Future<void> mediumImpact() async {
    if (!enabled) {
      return;
    }
    await HapticFeedback.mediumImpact();
  }
}

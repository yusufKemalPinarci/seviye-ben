import 'dart:convert';

import '../models/habit.dart';
import '../models/player.dart';
import 'content_loader.dart';
import 'local_store.dart';

class BackupException implements Exception {
  BackupException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Offline JSON yedek — ağ kullanmaz.
class BackupService {
  BackupService._();

  static const appId = 'seviye_ben';
  static const schemaVersion = 1;
  static const maxSupportedSchema = 1;

  static Map<String, dynamic> buildDataBlob() {
    return LocalStore.exportSnapshot();
  }

  static String encodeSnapshot({
    Map<String, dynamic>? data,
    String appVersion = '1.0.0+1',
    DateTime? exportedAt,
  }) {
    final blob = data ?? buildDataBlob();
    return const JsonEncoder.withIndent('  ').convert({
      'schemaVersion': schemaVersion,
      'appId': appId,
      'exportedAt': (exportedAt ?? DateTime.now()).toIso8601String(),
      'appVersion': appVersion,
      'data': blob,
    });
  }

  static String suggestFileName([DateTime? now]) {
    final d = now ?? DateTime.now();
    final day =
        '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
    return 'seviyeben_yedek_$day.json';
  }

  /// Ham JSON → doğrulanmış `data` haritası (sanitize edilmiş).
  static Map<String, dynamic> parseAndValidate(
    String raw, {
    GameContent? content,
  }) {
    late final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      throw BackupException('invalid');
    }
    if (decoded is! Map) {
      throw BackupException('invalid');
    }
    final root = Map<String, dynamic>.from(decoded);
    if (root['appId'] != appId) {
      throw BackupException('invalid');
    }
    final version = root['schemaVersion'];
    if (version is! int) {
      throw BackupException('invalid');
    }
    if (version > maxSupportedSchema) {
      throw BackupException('tooNew');
    }
    if (version < 1) {
      throw BackupException('invalid');
    }
    final dataRaw = root['data'];
    if (dataRaw is! Map) {
      throw BackupException('invalid');
    }
    final data = Map<String, dynamic>.from(dataRaw);
    if (data['player'] is! Map || data['habits'] is! List) {
      throw BackupException('invalid');
    }
    if (data['inventory'] is! Map || data['settings'] is! Map) {
      throw BackupException('invalid');
    }

    // Parse smoke — bozuk alanları erken yakala
    try {
      Player.fromJson(Map<String, dynamic>.from(data['player'] as Map));
      for (final h in data['habits'] as List) {
        if (h is! Map) {
          throw BackupException('invalid');
        }
        Habit.fromJson(Map<String, dynamic>.from(h));
      }
    } catch (e) {
      if (e is BackupException) {
        rethrow;
      }
      throw BackupException('invalid');
    }

    return sanitizeData(data, content ?? ContentLoader.requireCache);
  }

  static Map<String, dynamic> sanitizeData(
    Map<String, dynamic> data,
    GameContent content,
  ) {
    final inv = Map<String, dynamic>.from(data['inventory'] as Map);
    final unlockedRaw = inv['unlocked'];
    final unlocked = unlockedRaw is List
        ? unlockedRaw
            .map((e) => e.toString())
            .where((id) => content.equipmentById(id) != null)
            .toList()
        : <String>[];
    final equippedRaw = inv['equipped'];
    final equipped = <String, String>{};
    if (equippedRaw is Map) {
      equippedRaw.forEach((k, v) {
        final id = v.toString();
        if (content.equipmentById(id) != null && unlocked.contains(id)) {
          equipped[k.toString()] = id;
        }
      });
    }
    inv['unlocked'] = unlocked;
    inv['equipped'] = equipped;

    final settings = Map<String, dynamic>.from(data['settings'] as Map);
    final achRaw = settings['achievementIds'];
    final achIds = achRaw is List
        ? achRaw
            .map((e) => e.toString())
            .where((id) => content.achievementById(id) != null)
            .toList()
        : <String>[];
    settings['achievementIds'] = achIds;

    return {
      'player': data['player'],
      'habits': data['habits'],
      'inventory': inv,
      'settings': settings,
    };
  }

  static Future<void> applyToHive(Map<String, dynamic> sanitized) {
    return LocalStore.importSnapshot(sanitized);
  }
}

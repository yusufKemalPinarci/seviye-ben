import '../models/daily_quest.dart';

String titleForLevel(int level, List<LevelTitle> titles) {
  if (titles.isEmpty) {
    return 'Gezgin';
  }
  final sorted = [...titles]..sort((a, b) => a.minLevel.compareTo(b.minLevel));
  var current = sorted.first.title;
  for (final t in sorted) {
    if (level >= t.minLevel) {
      current = t.title;
    }
  }
  return current;
}

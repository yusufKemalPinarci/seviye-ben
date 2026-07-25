String todayKey([DateTime? now]) {
  final d = now ?? DateTime.now();
  return '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

String yesterdayKey([DateTime? now]) {
  final d = now ?? DateTime.now();
  final y = DateTime(d.year, d.month, d.day - 1);
  return todayKey(y);
}

int dayOfYear([DateTime? now]) {
  final d = now ?? DateTime.now();
  final start = DateTime(d.year);
  return d.difference(start).inDays;
}

/// Haftanın Pazartesi günü (yyyy-MM-dd).
String weekStartKey([DateTime? now]) {
  final d = now ?? DateTime.now();
  final day = DateTime(d.year, d.month, d.day);
  final monday = day.subtract(Duration(days: day.weekday - DateTime.monday));
  return todayKey(monday);
}

DateTime? parseDayKey(String key) {
  final parts = key.split('-');
  if (parts.length != 3) {
    return null;
  }
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (y == null || m == null || day == null) {
    return null;
  }
  return DateTime(y, m, day);
}

/// [dates] içinden [weekStart] ile başlayan 7 güne düşenler.
List<String> datesInWeek(List<String> dates, String weekStart) {
  final start = parseDayKey(weekStart);
  if (start == null) {
    return const [];
  }
  final end = start.add(const Duration(days: 6));
  final endKey = todayKey(end);
  return dates
      .where((k) => k.compareTo(weekStart) >= 0 && k.compareTo(endKey) <= 0)
      .toList();
}

/// Yıl içi hafta indeksi (Pazartesi haftaları; rotasyon için).
int weekIndex([DateTime? now]) {
  final d = now ?? DateTime.now();
  final start = DateTime(d.year, 1, 1);
  final monday = DateTime(d.year, d.month, d.day)
      .subtract(Duration(days: d.weekday - DateTime.monday));
  return monday.difference(start).inDays ~/ 7;
}

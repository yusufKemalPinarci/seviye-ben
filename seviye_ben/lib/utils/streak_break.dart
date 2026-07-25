import '../models/habit.dart';
import 'date_keys.dart';

/// En az bu kadar günlük seri kaybında uyarı gösterilir.
const int minStreakToWarn = 2;

/// Son bitirme dünden önceyse (ve bugün bitmemişse) seri kırılmış sayılır.
bool isHabitStreakBroken(Habit habit, [DateTime? now]) {
  if (habit.streak < minStreakToWarn) {
    return false;
  }
  final lastRaw = habit.lastCompletedDate;
  if (lastRaw == null) {
    return true;
  }
  final today = todayKey(now);
  if (lastRaw == today) {
    return false;
  }
  final yesterday = yesterdayKey(now);
  if (lastRaw == yesterday) {
    return false;
  }
  return true;
}

class StreakBreakInfo {
  const StreakBreakInfo({
    required this.habitTitle,
    required this.lostStreak,
  });

  final String habitTitle;
  final int lostStreak;
}

List<StreakBreakInfo> findBrokenStreaks(
  List<Habit> habits, [
  DateTime? now,
]) {
  final result = <StreakBreakInfo>[];
  for (final h in habits) {
    if (isHabitStreakBroken(h, now)) {
      result.add(
        StreakBreakInfo(habitTitle: h.title, lostStreak: h.streak),
      );
    }
  }
  return result;
}

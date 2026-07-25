import '../models/habit.dart';
import '../models/stat_type.dart';

List<Habit> filterHabitsByStat(List<Habit> habits, StatType? filter) {
  if (filter == null) {
    return habits;
  }
  return habits.where((h) => h.stat == filter).toList();
}

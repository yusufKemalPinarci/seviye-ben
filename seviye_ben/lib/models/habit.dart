import 'stat_type.dart';

class Habit {
  Habit({
    required this.id,
    required this.title,
    required this.stat,
    this.xpReward = 10,
    this.streak = 0,
    this.lastCompletedDate,
  });

  final String id;
  final String title;
  final StatType stat;
  final int xpReward;
  final int streak;
  final String? lastCompletedDate; // yyyy-MM-dd

  bool get completedToday {
    if (lastCompletedDate == null) {
      return false;
    }
    final now = DateTime.now();
    final today =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
    return lastCompletedDate == today;
  }

  Habit copyWith({
    String? title,
    StatType? stat,
    int? xpReward,
    int? streak,
    String? lastCompletedDate,
    bool clearLastCompleted = false,
  }) {
    return Habit(
      id: id,
      title: title ?? this.title,
      stat: stat ?? this.stat,
      xpReward: xpReward ?? this.xpReward,
      streak: streak ?? this.streak,
      lastCompletedDate: clearLastCompleted
          ? null
          : (lastCompletedDate ?? this.lastCompletedDate),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'stat': stat.name,
      'xpReward': xpReward,
      'streak': streak,
      'lastCompletedDate': lastCompletedDate,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      title: json['title'] as String,
      stat: StatTypeLabel.fromKey(json['stat'] as String),
      xpReward: json['xpReward'] as int? ?? 10,
      streak: json['streak'] as int? ?? 0,
      lastCompletedDate: json['lastCompletedDate'] as String?,
    );
  }
}

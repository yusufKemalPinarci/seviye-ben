class DailyQuest {
  const DailyQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.targetCount,
    required this.bonusXp,
  });

  final String id;
  final String title;
  final String description;
  final int targetCount;
  final int bonusXp;

  factory DailyQuest.fromJson(Map<String, dynamic> json) {
    return DailyQuest(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      targetCount: json['targetCount'] as int,
      bonusXp: json['bonusXp'] as int,
    );
  }
}

class LevelTitle {
  const LevelTitle({required this.minLevel, required this.title});

  final int minLevel;
  final String title;

  factory LevelTitle.fromJson(Map<String, dynamic> json) {
    return LevelTitle(
      minLevel: json['minLevel'] as int,
      title: json['title'] as String,
    );
  }
}

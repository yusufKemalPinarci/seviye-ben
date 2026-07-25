class WeeklyChallenge {
  const WeeklyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDays,
    required this.bonusXp,
  });

  final String id;
  final String title;
  final String description;
  final int targetDays;
  final int bonusXp;

  factory WeeklyChallenge.fromJson(Map<String, dynamic> json) {
    return WeeklyChallenge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      targetDays: json['targetDays'] as int? ?? 7,
      bonusXp: json['bonusXp'] as int? ?? 80,
    );
  }
}

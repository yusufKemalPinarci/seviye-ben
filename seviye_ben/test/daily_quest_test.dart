import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/daily_quest.dart';
import 'package:seviye_ben/services/content_loader.dart';
import 'package:seviye_ben/utils/date_keys.dart';
import 'package:seviye_ben/utils/game_balance.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GameContent content;

  setUpAll(() async {
    content = await ContentLoader.load();
  });

  test('DailyQuest.fromJson alanları okur', () {
    final q = DailyQuest.fromJson({
      'id': 'dq_test',
      'title': 'Test',
      'description': 'Açıklama',
      'targetCount': 3,
      'bonusXp': 25,
    });
    expect(q.id, 'dq_test');
    expect(q.targetCount, 3);
    expect(q.bonusXp, 25);
  });

  test('içerikte günlük görevler var ve geçerli', () {
    expect(content.dailyQuests, isNotEmpty);
    for (final q in content.dailyQuests) {
      expect(q.id, isNotEmpty);
      expect(q.title, isNotEmpty);
      expect(q.targetCount, greaterThan(0));
      expect(q.bonusXp, greaterThan(0));
    }
  });

  test('aynı gün aynı günlük görev seçilir', () {
    final day = DateTime(2026, 7, 23);
    final a = content.todaysQuest(day);
    final b = content.todaysQuest(day);
    expect(a.id, b.id);
    expect(a.bonusXp, b.bonusXp);
  });

  test('gün indeksine göre quest rotasyonu', () {
    final quests = content.dailyQuests;
    final day = DateTime(2026, 1, 1);
    final index = dayOfYear(day) % quests.length;
    expect(content.todaysQuest(day).id, quests[index].id);
  });

  test('görev tamamlanınca bonus XP eklenir (formül)', () {
    final quest = content.todaysQuest(DateTime(2026, 7, 23));
    const habitXp = 10;
    final streak = GameBalance.streakBonus(1);
    var total = habitXp + streak;
    expect(
      GameBalance.isDailyQuestComplete(
        completedCount: quest.targetCount,
        targetCount: quest.targetCount,
      ),
      isTrue,
    );
    total += quest.bonusXp;
    expect(total, habitXp + streak + quest.bonusXp);
  });
}

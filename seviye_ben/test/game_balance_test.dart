import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/utils/game_balance.dart';

void main() {
  group('GameBalance XP / seviye', () {
    test('ekonomi tablosu: kümülatif XP eşikleri', () {
      expect(GameBalance.xpForLevel(1), 0);
      expect(GameBalance.xpForLevel(2), 70);
      expect(GameBalance.xpForLevel(3), 155);
      expect(GameBalance.xpForLevel(5), 370);
      // sum(i=2..10, 40 + i×15) = 1170
      expect(GameBalance.xpForLevel(10), 1170);
    });

    test('levelFromXp eşiklerde doğru seviye', () {
      expect(GameBalance.levelFromXp(0), 1);
      expect(GameBalance.levelFromXp(69), 1);
      expect(GameBalance.levelFromXp(70), 2);
      expect(GameBalance.levelFromXp(154), 2);
      expect(GameBalance.levelFromXp(155), 3);
      expect(GameBalance.levelFromXp(370), 5);
      expect(GameBalance.levelFromXp(1170), 10);
    });

    test('seviye içi ilerleme ve sonraki seviye ihtiyacı', () {
      expect(GameBalance.xpProgressInLevel(70), 0);
      expect(GameBalance.xpNeededForNextLevel(70), 85);
      expect(GameBalance.xpProgressInLevel(100), 30);
      expect(GameBalance.xpNeededForNextLevel(100), 85);
    });
  });

  group('GameBalance streak', () {
    test('min(seri × 2, 20)', () {
      expect(GameBalance.streakBonus(0), 0);
      expect(GameBalance.streakBonus(1), 2);
      expect(GameBalance.streakBonus(5), 10);
      expect(GameBalance.streakBonus(10), 20);
      expect(GameBalance.streakBonus(50), 20);
    });
  });

  group('GameBalance günlük görev', () {
    test('hedefe ulaşınca tamam', () {
      expect(
        GameBalance.isDailyQuestComplete(completedCount: 2, targetCount: 3),
        isFalse,
      );
      expect(
        GameBalance.isDailyQuestComplete(completedCount: 3, targetCount: 3),
        isTrue,
      );
      expect(
        GameBalance.isDailyQuestComplete(completedCount: 4, targetCount: 3),
        isTrue,
      );
    });
  });
}

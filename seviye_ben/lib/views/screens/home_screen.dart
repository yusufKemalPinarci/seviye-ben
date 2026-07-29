import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/equipment.dart';
import '../../models/stat_type.dart';
import '../../utils/game_balance.dart';
import '../../viewmodels/game_notifier.dart';
import '../widgets/daily_quest_card.dart';
import '../widgets/habit_list_sliver.dart';
import '../widgets/level_up_celebration.dart';
import '../widgets/player_header.dart';
import '../widgets/street_line_card.dart';
import '../widgets/streak_break_banner.dart';
import '../widgets/today_summary_card.dart';
import '../widgets/weekly_challenge_card.dart';
import 'add_habit_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  StatType? _statFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SeviyeBen'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                'SOKAK RPG',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const _HomeFeedbackListener(),
          CustomScrollView(
            cacheExtent: 240,
            slivers: [
              // Önce aksiyon: HUD + kısa ipucu + rutin listesi.
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _HomePlayerHeader(),
                      const SizedBox(height: 12),
                      const _HomeStreetLine(),
                      const _HomeStreakBreak(),
                      const SizedBox(height: 8),
                      const _HomeTodayGoalsCollapsed(),
                      const SizedBox(height: 16),
                      Text(
                        'Bugünün görevleri',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          FilterChip(
                            label: const Text('Tümü'),
                            selected: _statFilter == null,
                            onSelected: (_) =>
                                setState(() => _statFilter = null),
                          ),
                          ...StatType.values.map(
                            (stat) => FilterChip(
                              label: Text(stat.labelTr),
                              selected: _statFilter == stat,
                              onSelected: (_) =>
                                  setState(() => _statFilter = stat),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: HabitListSliver(statFilter: _statFilter),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result =
              await showModalBottomSheet<({String title, StatType stat})>(
            context: context,
            isScrollControlled: true,
            builder: (_) => const HabitFormSheet(),
          );
          if (result != null) {
            await ref
                .read(gameProvider.notifier)
                .addHabit(result.title, result.stat);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('+ Görev'),
      ),
    );
  }
}

/// Seviye / görev / başarım geri bildirimlerini dinler; listeyi yeniden kurmaz.
class _HomeFeedbackListener extends ConsumerWidget {
  const _HomeFeedbackListener();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedback = ref.watch(
      gameProvider.select(
        (s) => (
          lastLevelUp: s.lastLevelUp,
          dailyQuestJustCompleted: s.dailyQuestJustCompleted,
          dailyQuestBonusXp: s.dailyQuestBonusXp,
          weeklyChallengeJustCompleted: s.weeklyChallengeJustCompleted,
          weeklyChallengeBonusXp: s.weeklyChallengeBonusXp,
          lastAchievementTitles: s.lastAchievementTitles,
          levelMessage: s.levelMessage,
          lastUnlockNames: s.lastUnlockNames,
          lastUnlockIds: s.lastUnlockIds,
          lookIndex: s.player.lookIndex,
          equipped: s.equippedBySlot,
          player: s.player,
          content: s.content,
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) {
        return;
      }
      final leveled = feedback.lastLevelUp;
      final parts = <String>[];
      if (feedback.dailyQuestJustCompleted &&
          feedback.dailyQuestBonusXp != null) {
        parts.add('Günlük görev +${feedback.dailyQuestBonusXp} XP');
      }
      if (feedback.weeklyChallengeJustCompleted &&
          feedback.weeklyChallengeBonusXp != null) {
        parts.add('Haftalık meydan +${feedback.weeklyChallengeBonusXp} XP');
      }
      if (feedback.lastAchievementTitles.isNotEmpty) {
        parts.add(
          'Başarım: ${feedback.lastAchievementTitles.join(', ')}',
        );
      }
      if (leveled == null && parts.isEmpty) {
        return;
      }

      final levelMessage = feedback.levelMessage;
      final unlockNames = List<String>.from(feedback.lastUnlockNames);
      final unlockGear = feedback.lastUnlockIds
          .map(feedback.content.equipmentById)
          .whereType<Equipment>()
          .toList();
      final lookIndex = feedback.lookIndex;
      final equipped = feedback.equipped;
      final player = feedback.player;

      ref.read(gameProvider.notifier).clearFeedbackFlags();

      if (parts.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(parts.join(' · ')),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }

      if (leveled != null && context.mounted) {
        await showLevelUpCelebration(
          context,
          level: leveled,
          lookIndex: lookIndex,
          equipped: equipped,
          player: player,
          message: levelMessage,
          unlockNames: unlockNames,
          unlockGear: unlockGear,
        );
      }
    });

    return const SizedBox.shrink();
  }
}

class _HomePlayerHeader extends ConsumerWidget {
  const _HomePlayerHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final header = ref.watch(
      gameProvider.select(
        (s) => (
          player: s.player,
          level: s.level,
          title: s.title,
          equipped: s.equippedBySlot,
          habitCompletePulse: s.habitCompletePulse,
          lastHabitStat: s.lastHabitStat,
          gearBonuses: {
            for (final st in StatType.values) st: s.bonusFor(st),
          },
        ),
      ),
    );
    final xpIn = GameBalance.xpProgressInLevel(header.player.xp);
    final xpNeed = GameBalance.xpNeededForNextLevel(header.player.xp);

    return PlayerHeader(
      player: header.player,
      level: header.level,
      title: header.title,
      xpInLevel: xpIn,
      xpNeeded: xpNeed,
      equipped: header.equipped,
      gearBonuses: header.gearBonuses,
      habitCompletePulse: header.habitCompletePulse,
      sparkleStat: header.lastHabitStat,
    );
  }
}

class _HomeStreetLine extends ConsumerWidget {
  const _HomeStreetLine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final line = ref.watch(
      gameProvider.select((s) => s.content.todaysStreetLine()),
    );
    return StreetLineCard(line: line);
  }
}

class _HomeStreakBreak extends ConsumerWidget {
  const _HomeStreakBreak();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breaks = ref.watch(gameProvider.select((s) => s.streakBreaks));
    if (breaks.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: StreakBreakBanner(
        breaks: breaks,
        onDismiss: () {
          ref.read(gameProvider.notifier).clearStreakBreakNotice();
        },
      ),
    );
  }
}

/// Günlük / haftalık / özet — varsayılan kapalı; ilk viewport’ta Bitir kalır.
class _HomeTodayGoalsCollapsed extends ConsumerWidget {
  const _HomeTodayGoalsCollapsed();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(
      gameProvider.select(
        (s) => (
          dailyDone: s.completedHabitsToday,
          dailyTarget: s.todaysQuest.targetCount,
          weeklyDone: s.weeklyDaysProgress,
          weeklyTarget: s.thisWeeksChallenge.targetDays,
          xpToday: s.xpEarnedToday,
          dailyComplete: s.isDailyQuestDone,
          weeklyComplete: s.isWeeklyChallengeDone,
        ),
      ),
    );
    final hint =
        'Günlük ${summary.dailyDone}/${summary.dailyTarget}'
        ' · Hafta ${summary.weeklyDone}/${summary.weeklyTarget}'
        ' · +${summary.xpToday} XP';

    return Material(
      color: Colors.transparent,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.35),
            ),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.35),
            ),
          ),
          leading: Icon(
            summary.dailyComplete && summary.weeklyComplete
                ? Icons.check_circle
                : Icons.flag_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: const Text(
            'Bugünün hedefleri',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
          subtitle: Text(
            hint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  _HomeDailyQuest(),
                  SizedBox(height: 12),
                  _HomeWeeklyChallenge(),
                  SizedBox(height: 12),
                  _HomeTodaySummary(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeDailyQuest extends ConsumerWidget {
  const _HomeDailyQuest();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(
      gameProvider.select(
        (s) => (
          quest: s.todaysQuest,
          progress: s.completedHabitsToday,
          done: s.isDailyQuestDone,
          dayStreak: s.player.dayStreak,
        ),
      ),
    );
    return DailyQuestCard(
      quest: data.quest,
      progress: data.progress,
      done: data.done,
      dayStreak: data.dayStreak,
    );
  }
}

class _HomeWeeklyChallenge extends ConsumerWidget {
  const _HomeWeeklyChallenge();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(
      gameProvider.select(
        (s) => (
          challenge: s.thisWeeksChallenge,
          progressDays: s.weeklyDaysProgress,
          done: s.isWeeklyChallengeDone,
        ),
      ),
    );
    return WeeklyChallengeCard(
      challenge: data.challenge,
      progressDays: data.progressDays,
      done: data.done,
    );
  }
}

class _HomeTodaySummary extends ConsumerWidget {
  const _HomeTodaySummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(
      gameProvider.select(
        (s) => (
          routinesDone: s.completedHabitsToday,
          xpEarned: s.xpEarnedToday,
        ),
      ),
    );
    return TodaySummaryCard(
      routinesDone: data.routinesDone,
      xpEarned: data.xpEarned,
    );
  }
}

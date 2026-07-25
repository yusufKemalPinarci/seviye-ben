import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/local_store.dart';
import '../../viewmodels/game_notifier.dart';
import 'main_shell.dart';
import 'onboarding_screen.dart';

class AppGate extends ConsumerStatefulWidget {
  const AppGate({super.key});

  @override
  ConsumerState<AppGate> createState() => _AppGateState();
}

class _AppGateState extends ConsumerState<AppGate> {
  late bool _ready;
  late bool _onboardingDone;

  @override
  void initState() {
    super.initState();
    _onboardingDone = LocalStore.isOnboardingDone();
    _ready = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(gameProvider.notifier).syncAchievements();
      await ref.read(gameProvider.notifier).checkBrokenStreaks();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!_onboardingDone) {
      return OnboardingScreen(
        onFinished: () => setState(() => _onboardingDone = true),
      );
    }
    return const MainShell();
  }
}

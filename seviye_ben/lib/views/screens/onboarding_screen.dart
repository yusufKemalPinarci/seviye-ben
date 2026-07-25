import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/game_notifier.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = TextEditingController();
  var _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(gameProvider.notifier).completeOnboarding(_controller.text);
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _page == 0 ? _welcome(context) : _nameStep(context),
        ),
      ),
    );
  }

  Widget _welcome(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Text(
          'SeviyeBen',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'Hayatını RPG’ye çevir.\nRutin bitir, XP kap, sokakta seviye atla.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Güç · Zeka · Enerji · Can — hepsi ofline, hesap yok.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(
                      alpha: 0.7,
                    ),
              ),
        ),
        const Spacer(),
        FilledButton(
          onPressed: () => setState(() => _page = 1),
          child: const Text('Başla'),
        ),
      ],
    );
  }

  Widget _nameStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Text(
          'Sana ne diyelim?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          autofocus: true,
          maxLength: 20,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _finish(),
          decoration: const InputDecoration(
            labelText: 'İsim',
            hintText: 'Gezgin',
            border: OutlineInputBorder(),
          ),
        ),
        const Spacer(),
        FilledButton(
          onPressed: _finish,
          child: const Text('Maceraya gir'),
        ),
      ],
    );
  }
}

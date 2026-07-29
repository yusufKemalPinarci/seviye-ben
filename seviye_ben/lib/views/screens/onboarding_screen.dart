import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/app_theme.dart';
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

  static const _pageCount = 3;

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
          child: switch (_page) {
            0 => _welcome(context),
            1 => _loopDemo(context),
            _ => _nameStep(context),
          },
        ),
      ),
    );
  }

  Widget _welcome(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PageDots(page: _page, count: _pageCount),
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
          child: const Text('Nasıl çalışır?'),
        ),
      ],
    );
  }

  Widget _loopDemo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PageDots(page: _page, count: _pageCount),
        const Spacer(),
        Text(
          'Sokak döngüsü',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Üç adımda seviye atlıyorsun — hepsi cihazda.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.onSurfaceMuted,
              ),
        ),
        const SizedBox(height: 20),
        const _LoopStep(
          number: '1',
          title: 'Bitir',
          body: 'Günün rutinine dokun. Seri ve XP anında yazılır.',
          color: AppTheme.signal,
        ),
        const SizedBox(height: 12),
        const _LoopStep(
          number: '2',
          title: 'XP ve seviye',
          body: 'XP dolar; seviye atlayınca yeni ekipman açılır.',
          color: AppTheme.xpGold,
        ),
        const SizedBox(height: 12),
        const _LoopStep(
          number: '3',
          title: 'Giy ve güçlen',
          body: 'Envanterden giy — karakterin sokakta değişir.',
          color: AppTheme.street,
        ),
        const Spacer(),
        FilledButton(
          onPressed: () => setState(() => _page = 2),
          child: const Text('Anladım'),
        ),
        TextButton(
          onPressed: () => setState(() => _page = 0),
          child: const Text('Geri'),
        ),
      ],
    );
  }

  Widget _nameStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PageDots(page: _page, count: _pageCount),
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
        TextButton(
          onPressed: () => setState(() => _page = 1),
          child: const Text('Geri'),
        ),
      ],
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.page, required this.count});

  final int page;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == page;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active
                ? AppTheme.signal
                : AppTheme.street.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}

class _LoopStep extends StatelessWidget {
  const _LoopStep({
    required this.number,
    required this.title,
    required this.body,
    required this.color,
  });

  final String number;
  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.gamePanel(
        borderColor: color.withValues(alpha: 0.4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color),
            ),
            child: Text(
              number,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.onSurfaceMuted,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

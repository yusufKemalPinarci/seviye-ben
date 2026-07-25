import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/equipment.dart';
import '../../services/haptic_service.dart';
import '../../utils/app_theme.dart';
import 'character_avatar.dart';

Future<void> showLevelUpCelebration(
  BuildContext context, {
  required int level,
  required int lookIndex,
  required Map<EquipSlot, Equipment?> equipped,
  String? message,
  List<String> unlockNames = const [],
}) {
  HapticService.mediumImpact();
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Seviye atladın',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (context, animation, secondaryAnimation) {
      return LevelUpCelebration(
        level: level,
        lookIndex: lookIndex,
        equipped: equipped,
        message: message,
        unlockNames: unlockNames,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: curved, child: child),
      );
    },
  );
}

class LevelUpCelebration extends StatefulWidget {
  const LevelUpCelebration({
    super.key,
    required this.level,
    required this.lookIndex,
    required this.equipped,
    this.message,
    this.unlockNames = const [],
  });

  final int level;
  final int lookIndex;
  final Map<EquipSlot, Equipment?> equipped;
  final String? message;
  final List<String> unlockNames;

  @override
  State<LevelUpCelebration> createState() => _LevelUpCelebrationState();
}

class _LevelUpCelebrationState extends State<LevelUpCelebration>
    with TickerProviderStateMixin {
  static const _autoClose = Duration(milliseconds: 2200);

  late final AnimationController _bounce;
  late final AnimationController _party;
  late final Animation<double> _scale;
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.85, end: 1.14)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.14, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 55,
      ),
    ]).animate(_bounce);

    _party = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();

    _autoCloseTimer = Timer(_autoClose, () {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    _bounce.dispose();
    _party.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = widget.message ?? 'Sokakta bir basamak daha.';
    final unlockText = widget.unlockNames.isEmpty
        ? null
        : 'Yeni açılan: ${widget.unlockNames.join(', ')}';

    return Center(
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 28),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            decoration: BoxDecoration(
              color: AppTheme.asphalt,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.signal, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.ink.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 168,
                  width: double.infinity,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_bounce, _party]),
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _ConfettiPainter(progress: _party.value),
                        child: Center(
                          child: Transform.scale(
                            scale: _scale.value,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: CharacterAvatar(
                      lookIndex: widget.lookIndex,
                      level: widget.level,
                      equipped: widget.equipped,
                      size: 132,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Seviye atladın!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.street,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Seviye ${widget.level}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppTheme.signal,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.onSurfaceMuted,
                      ),
                ),
                if (unlockText != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    unlockText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.street,
                        ),
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.street,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  child: const Text('Devam'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress});

  final double progress;

  static const _colors = [
    AppTheme.signal,
    AppTheme.street,
    Color(0xFFF2C94C),
    Color(0xFF4A90A4),
    Color(0xFFE8E4DC),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(42);
    final paint = Paint();
    for (var i = 0; i < 28; i++) {
      final t = (progress + i * 0.03) % 1.0;
      final x = rnd.nextDouble() * size.width;
      final startY = -12.0 - rnd.nextDouble() * 40;
      final y = startY + t * (size.height + 60);
      final w = 4.0 + rnd.nextDouble() * 5;
      final h = 6.0 + rnd.nextDouble() * 8;
      paint.color = _colors[i % _colors.length].withValues(
        alpha: (1.0 - t * 0.55).clamp(0.2, 1.0),
      );
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * math.pi * 2 + i);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: w, height: h),
          const Radius.circular(1.5),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

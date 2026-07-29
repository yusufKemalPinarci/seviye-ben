import 'package:flutter/material.dart';

import '../../models/equipment.dart';
import '../../models/stat_type.dart';
import '../../utils/app_theme.dart';
import 'character_avatar.dart';

/// Idle nefes + Bitir bounce (+ isteğe bağlı sparkle) sarmalayıcısı.
class AnimatedCharacterAvatar extends StatefulWidget {
  const AnimatedCharacterAvatar({
    super.key,
    required this.lookIndex,
    required this.level,
    required this.equipped,
    this.strength = 1,
    this.intellect = 1,
    this.energy = 1,
    this.vitality = 1,
    this.size = 180,
    this.showLevelBadge = true,
    this.showStatAura = true,
    this.enableIdle = true,
    this.enableBounce = true,
    this.habitCompletePulse = 0,
    this.sparkleStat,
  });

  final int lookIndex;
  final int level;
  final Map<EquipSlot, Equipment?> equipped;
  final int strength;
  final int intellect;
  final int energy;
  final int vitality;
  final double size;
  final bool showLevelBadge;
  final bool showStatAura;
  final bool enableIdle;
  final bool enableBounce;
  final int habitCompletePulse;
  /// Habit bitince sparkle rengi; null = sparkle yok.
  final StatType? sparkleStat;

  static const idleDuration = Duration(milliseconds: 2400);
  static const idleAmplitude = 2.0;
  static const bounceDuration = Duration(milliseconds: 400);
  static const bouncePeakScale = 1.07;
  static const sparkleDuration = Duration(milliseconds: 520);

  @override
  State<AnimatedCharacterAvatar> createState() =>
      _AnimatedCharacterAvatarState();
}

class _AnimatedCharacterAvatarState extends State<AnimatedCharacterAvatar>
    with TickerProviderStateMixin {
  AnimationController? _idle;
  AnimationController? _bounce;
  AnimationController? _sparkle;
  Animation<double>? _idleOffset;
  Animation<double>? _bounceScale;

  @override
  void initState() {
    super.initState();
    _setupControllers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncIdleRunning();
  }

  @override
  void didUpdateWidget(covariant AnimatedCharacterAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.habitCompletePulse != widget.habitCompletePulse) {
      _triggerBounce();
      _triggerSparkle();
    }
    if (oldWidget.enableIdle != widget.enableIdle) {
      _syncIdleRunning();
    }
  }

  void _setupControllers() {
    _idle = AnimationController(
      vsync: this,
      duration: AnimatedCharacterAvatar.idleDuration,
    );
    _idleOffset = Tween<double>(
      begin: -AnimatedCharacterAvatar.idleAmplitude,
      end: AnimatedCharacterAvatar.idleAmplitude,
    ).animate(CurvedAnimation(parent: _idle!, curve: Curves.easeInOut));

    _bounce = AnimationController(
      vsync: this,
      duration: AnimatedCharacterAvatar.bounceDuration,
    );
    _bounceScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: AnimatedCharacterAvatar.bouncePeakScale)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(begin: AnimatedCharacterAvatar.bouncePeakScale, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 55,
      ),
    ]).animate(_bounce!);

    _sparkle = AnimationController(
      vsync: this,
      duration: AnimatedCharacterAvatar.sparkleDuration,
    );
  }

  bool get _reduceMotion => MediaQuery.disableAnimationsOf(context);

  void _syncIdleRunning() {
    final idle = _idle;
    if (idle == null) {
      return;
    }
    if (widget.enableIdle && !_reduceMotion) {
      if (!idle.isAnimating) {
        idle.repeat(reverse: true);
      }
    } else {
      idle.stop();
      idle.value = 0.5;
    }
  }

  void _triggerBounce() {
    if (!widget.enableBounce || _reduceMotion) {
      return;
    }
    _bounce?.forward(from: 0);
  }

  void _triggerSparkle() {
    if (widget.sparkleStat == null || _reduceMotion) {
      return;
    }
    _sparkle?.forward(from: 0);
  }

  @override
  void dispose() {
    _idle?.dispose();
    _bounce?.dispose();
    _sparkle?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = CharacterAvatar(
      key: ValueKey(
        [
          EquipSlot.values.map((s) => widget.equipped[s]?.id ?? '-').join('|'),
          widget.level,
          widget.strength,
          widget.intellect,
          widget.energy,
          widget.vitality,
        ].join(':'),
      ),
      lookIndex: widget.lookIndex,
      level: widget.level,
      equipped: widget.equipped,
      strength: widget.strength,
      intellect: widget.intellect,
      energy: widget.energy,
      vitality: widget.vitality,
      size: widget.size,
      showLevelBadge: widget.showLevelBadge,
      showStatAura: widget.showStatAura,
    );

    final idle = _idle;
    final bounce = _bounce;
    final sparkle = _sparkle;
    if (idle == null || bounce == null || sparkle == null) {
      return avatar;
    }

    return AnimatedBuilder(
      animation: Listenable.merge([idle, bounce, sparkle]),
      builder: (context, child) {
        final dy = widget.enableIdle && !_reduceMotion
            ? (_idleOffset?.value ?? 0)
            : 0.0;
        final scale = widget.enableBounce && !_reduceMotion
            ? (_bounceScale?.value ?? 1.0)
            : 1.0;
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.scale(
            scale: scale,
            child: CustomPaint(
              foregroundPainter: widget.sparkleStat != null && sparkle.value > 0
                  ? _SparklePainter(
                      progress: sparkle.value,
                      color: AppTheme.statColor(widget.sparkleStat!),
                    )
                  : null,
              child: child,
            ),
          ),
        );
      },
      child: avatar,
    );
  }
}

class _SparklePainter extends CustomPainter {
  _SparklePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.42;
    final paint = Paint()..color = color.withValues(alpha: 1.0 - progress);
    const seeds = [
      Offset(-0.28, -0.1),
      Offset(0.26, -0.18),
      Offset(-0.18, 0.22),
      Offset(0.22, 0.16),
      Offset(0.0, -0.32),
      Offset(-0.08, 0.08),
    ];
    for (var i = 0; i < seeds.length; i++) {
      final s = seeds[i];
      final t = (progress + i * 0.08) % 1.0;
      final r = size.shortestSide * (0.018 + t * 0.02);
      canvas.drawCircle(
        Offset(cx + s.dx * size.width, cy + s.dy * size.height - t * 12),
        r,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

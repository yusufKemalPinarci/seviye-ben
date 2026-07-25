import 'package:flutter/material.dart';

import '../../models/equipment.dart';
import 'character_avatar.dart';

/// Idle nefes + Bitir bounce sarmalayıcısı; çizim `CharacterAvatar`'da kalır.
class AnimatedCharacterAvatar extends StatefulWidget {
  const AnimatedCharacterAvatar({
    super.key,
    required this.lookIndex,
    required this.level,
    required this.equipped,
    this.size = 180,
    this.showLevelBadge = true,
    this.enableIdle = true,
    this.enableBounce = true,
    this.habitCompletePulse = 0,
  });

  final int lookIndex;
  final int level;
  final Map<EquipSlot, Equipment?> equipped;
  final double size;
  final bool showLevelBadge;
  final bool enableIdle;
  final bool enableBounce;
  final int habitCompletePulse;

  static const idleDuration = Duration(milliseconds: 2400);
  static const idleAmplitude = 2.0;
  static const bounceDuration = Duration(milliseconds: 400);
  static const bouncePeakScale = 1.07;

  @override
  State<AnimatedCharacterAvatar> createState() =>
      _AnimatedCharacterAvatarState();
}

class _AnimatedCharacterAvatarState extends State<AnimatedCharacterAvatar>
    with TickerProviderStateMixin {
  AnimationController? _idle;
  AnimationController? _bounce;
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

  @override
  void dispose() {
    _idle?.dispose();
    _bounce?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = CharacterAvatar(
      lookIndex: widget.lookIndex,
      level: widget.level,
      equipped: widget.equipped,
      size: widget.size,
      showLevelBadge: widget.showLevelBadge,
    );

    final idle = _idle;
    final bounce = _bounce;
    if (idle == null || bounce == null) {
      return avatar;
    }

    return AnimatedBuilder(
      animation: Listenable.merge([idle, bounce]),
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
            child: child,
          ),
        );
      },
      child: avatar,
    );
  }
}

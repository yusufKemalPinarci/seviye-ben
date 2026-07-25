import 'package:flutter/material.dart';

import '../../models/equipment.dart';
import '../../utils/app_theme.dart';
import '../../utils/equipment_look.dart';

/// Sokak gezgini paper-doll; giyilen ekipman katmanlarını çizer.
class CharacterAvatar extends StatelessWidget {
  const CharacterAvatar({
    super.key,
    required this.lookIndex,
    required this.level,
    required this.equipped,
    this.size = 180,
    this.showLevelBadge = true,
  });

  final int lookIndex;
  final int level;
  final Map<EquipSlot, Equipment?> equipped;
  final double size;
  final bool showLevelBadge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _AvatarPainter(
          look: lookStyleFor(lookIndex),
          level: level,
          equipped: equipped,
          showLevelBadge: showLevelBadge,
        ),
      ),
    );
  }
}

class _AvatarPainter extends CustomPainter {
  _AvatarPainter({
    required this.look,
    required this.level,
    required this.equipped,
    required this.showLevelBadge,
  });

  final LookStyle look;
  final int level;
  final Map<EquipSlot, Equipment?> equipped;
  final bool showLevelBadge;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final s = size.shortestSide;

    // zemin / gölge
    final ground = Paint()..color = AppTheme.street.withValues(alpha: 0.35);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, s * 0.92),
        width: s * 0.55,
        height: s * 0.08,
      ),
      ground,
    );

    final headEq = equipped[EquipSlot.head];
    final bodyEq = equipped[EquipSlot.body];
    final feetEq = equipped[EquipSlot.feet];
    final accEq = equipped[EquipSlot.accessory];

    // bacaklar
    final legPaint = Paint()..color = const Color(0xFF2C3340);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - s * 0.14, s * 0.58, s * 0.1, s * 0.28),
        Radius.circular(s * 0.03),
      ),
      legPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + s * 0.04, s * 0.58, s * 0.1, s * 0.28),
        Radius.circular(s * 0.03),
      ),
      legPaint,
    );

    // ayakkabı
    final feetKind = gearKindFor(feetEq?.id, EquipSlot.feet);
    final shoe = Paint()
      ..color = feetEq == null
          ? const Color(0xFF3A3A3A)
          : equipmentColor(feetEq.id, EquipSlot.feet);
    final shoeH = feetKind == GearKind.boot ? s * 0.08 : s * 0.055;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - s * 0.16, s * 0.82, s * 0.14, shoeH),
        Radius.circular(s * 0.02),
      ),
      shoe,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + s * 0.02, s * 0.82, s * 0.14, shoeH),
        Radius.circular(s * 0.02),
      ),
      shoe,
    );

    // gövde
    final bodyKind = gearKindFor(bodyEq?.id, EquipSlot.body);
    final torsoColor = bodyEq == null
        ? look.shirt
        : equipmentColor(bodyEq.id, EquipSlot.body);
    final torso = Paint()..color = torsoColor;
    final torsoTop = bodyKind == GearKind.hoodie || bodyKind == GearKind.coat
        ? s * 0.30
        : s * 0.32;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - s * 0.18, torsoTop, s * 0.36, s * 0.30),
        Radius.circular(s * 0.06),
      ),
      torso,
    );

    if (bodyKind == GearKind.hoodie || bodyKind == GearKind.coat) {
      final hood = Paint()..color = torsoColor.withValues(alpha: 0.9);
      canvas.drawCircle(Offset(cx, s * 0.28), s * 0.12, hood);
    }

    if (bodyKind == GearKind.bag) {
      final bag = Paint()..color = equipmentColor(bodyEq!.id, EquipSlot.body);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx + s * 0.12, s * 0.36, s * 0.12, s * 0.18),
          Radius.circular(s * 0.02),
        ),
        bag,
      );
    }

    // kollar
    final arm = Paint()..color = look.skin;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - s * 0.28, s * 0.34, s * 0.1, s * 0.22),
        Radius.circular(s * 0.04),
      ),
      arm,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + s * 0.18, s * 0.34, s * 0.1, s * 0.22),
        Radius.circular(s * 0.04),
      ),
      arm,
    );

    // kafa
    final head = Paint()..color = look.skin;
    canvas.drawCircle(Offset(cx, s * 0.22), s * 0.12, head);

    // saç
    final hair = Paint()..color = look.hair;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, s * 0.20), radius: s * 0.125),
      3.6,
      2.5,
      true,
      hair,
    );

    // yüz
    final eye = Paint()..color = AppTheme.ink;
    canvas.drawCircle(Offset(cx - s * 0.04, s * 0.21), s * 0.012, eye);
    canvas.drawCircle(Offset(cx + s * 0.04, s * 0.21), s * 0.012, eye);
    final smile = Paint()
      ..color = AppTheme.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.012
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx, s * 0.245),
        width: s * 0.08,
        height: s * 0.05,
      ),
      0.2,
      2.7,
      false,
      smile,
    );

    // baş ekipmanı
    final headKind = gearKindFor(headEq?.id, EquipSlot.head);
    if (headEq != null) {
      final hc = Paint()..color = equipmentColor(headEq.id, EquipSlot.head);
      switch (headKind) {
        case GearKind.beanie:
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset(cx, s * 0.12),
              width: s * 0.24,
              height: s * 0.14,
            ),
            hc,
          );
        case GearKind.cap:
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset(cx, s * 0.13),
              width: s * 0.26,
              height: s * 0.1,
            ),
            hc,
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(cx - s * 0.02, s * 0.14, s * 0.18, s * 0.035),
              Radius.circular(s * 0.01),
            ),
            hc,
          );
        case GearKind.bandana:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(cx - s * 0.13, s * 0.12, s * 0.26, s * 0.05),
              Radius.circular(s * 0.02),
            ),
            hc,
          );
        default:
          break;
      }
    }

    // aksesuar
    final accKind = gearKindFor(accEq?.id, EquipSlot.accessory);
    if (accEq != null) {
      final ac = Paint()..color = equipmentColor(accEq.id, EquipSlot.accessory);
      switch (accKind) {
        case GearKind.phones:
          canvas.drawCircle(Offset(cx - s * 0.13, s * 0.22), s * 0.04, ac);
          canvas.drawCircle(Offset(cx + s * 0.13, s * 0.22), s * 0.04, ac);
          final band = Paint()
            ..color = ac.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = s * 0.02;
          canvas.drawArc(
            Rect.fromCircle(center: Offset(cx, s * 0.18), radius: s * 0.14),
            3.5,
            2.3,
            false,
            band,
          );
        case GearKind.bottle:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(cx + s * 0.20, s * 0.42, s * 0.06, s * 0.14),
              Radius.circular(s * 0.015),
            ),
            ac,
          );
        case GearKind.watch:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(cx - s * 0.27, s * 0.48, s * 0.08, s * 0.05),
              Radius.circular(s * 0.01),
            ),
            ac,
          );
        default:
          break;
      }
    }

    if (showLevelBadge) {
      final badge = Paint()..color = AppTheme.signal;
      final br = s * 0.09;
      final bx = s * 0.82;
      final by = s * 0.12;
      canvas.drawCircle(Offset(bx, by), br, badge);
      final tp = TextPainter(
        text: TextSpan(
          text: '$level',
          style: TextStyle(
            color: AppTheme.ink,
            fontSize: s * 0.07,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(bx - tp.width / 2, by - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _AvatarPainter oldDelegate) {
    return oldDelegate.look != look ||
        oldDelegate.level != level ||
        oldDelegate.showLevelBadge != showLevelBadge ||
        !_sameGear(oldDelegate.equipped, equipped);
  }

  bool _sameGear(
    Map<EquipSlot, Equipment?> a,
    Map<EquipSlot, Equipment?> b,
  ) {
    for (final slot in EquipSlot.values) {
      if (a[slot]?.id != b[slot]?.id) {
        return false;
      }
    }
    return true;
  }
}

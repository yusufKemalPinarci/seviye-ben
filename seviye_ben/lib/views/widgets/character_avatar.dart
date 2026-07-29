import 'package:flutter/material.dart';

import '../../models/equipment.dart';
import '../../models/stat_type.dart';
import '../../utils/app_theme.dart';
import '../../utils/equipment_look.dart';
import '../../utils/progression_look.dart';

/// Sokak gezgini paper-doll; giyilen ekipman + seviye basamağı + stat aura.
class CharacterAvatar extends StatelessWidget {
  const CharacterAvatar({
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: AvatarPainter(
          look: lookStyleFor(lookIndex),
          level: level,
          equipped: equipped,
          strength: strength,
          intellect: intellect,
          energy: energy,
          vitality: vitality,
          showLevelBadge: showLevelBadge,
          showStatAura: showStatAura,
        ),
      ),
    );
  }
}

/// Test ve siluet için dışa açık painter.
class AvatarPainter extends CustomPainter {
  AvatarPainter({
    required this.look,
    required this.level,
    required this.equipped,
    required this.strength,
    required this.intellect,
    required this.energy,
    required this.vitality,
    required this.showLevelBadge,
    required this.showStatAura,
  });

  final LookStyle look;
  final int level;
  final Map<EquipSlot, Equipment?> equipped;
  final int strength;
  final int intellect;
  final int energy;
  final int vitality;
  final bool showLevelBadge;
  final bool showStatAura;

  StreetTier get tier => streetTierForLevel(level);

  StatType get dominant => dominantStat(
        strength: strength,
        intellect: intellect,
        energy: energy,
        vitality: vitality,
      );

  Paint _fill(Color c) => Paint()..color = c;

  Paint _stroke(Color c, double width) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeJoin = StrokeJoin.round;

  void _rrect(
    Canvas canvas,
    Rect rect,
    double radius,
    Color fill, {
    Color? outline,
    double strokeW = 1.5,
  }) {
    final rr = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.drawRRect(rr, _fill(fill));
    if (outline != null) {
      canvas.drawRRect(rr, _stroke(outline, strokeW));
    }
  }

  void _circle(
    Canvas canvas,
    Offset c,
    double r,
    Color fill, {
    Color? outline,
    double strokeW = 1.5,
  }) {
    canvas.drawCircle(c, r, _fill(fill));
    if (outline != null) {
      canvas.drawCircle(c, r, _stroke(outline, strokeW));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final s = size.shortestSide;
    final ink = AppTheme.ink.withValues(alpha: 0.55);
    final sw = (s * 0.012).clamp(1.0, 2.2);
    final shoulder = tier.shoulderExtra;
    final auraStat = dominant;
    final auraColor = AppTheme.statColor(auraStat);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, s * 0.92),
        width: s * 0.55,
        height: s * 0.08,
      ),
      _fill(AppTheme.street.withValues(alpha: 0.35)),
    );

    if (showStatAura) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, s * 0.52),
          width: s * (0.62 + shoulder * 4),
          height: s * 0.78,
        ),
        _fill(auraColor.withValues(alpha: 0.14)),
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, s * 0.52),
          width: s * (0.48 + shoulder * 3),
          height: s * 0.62,
        ),
        _stroke(auraColor.withValues(alpha: 0.35), sw * 1.2),
      );
    }

    // Basamak: ayaklardan ölçekle (siluet büyür / küçülür)
    final pivotY = s * 0.88;
    canvas.save();
    canvas.translate(cx, pivotY);
    canvas.scale(tier.scale, tier.scale);
    canvas.translate(-cx, -pivotY);

    final headEq = equipped[EquipSlot.head];
    final bodyEq = equipped[EquipSlot.body];
    final backEq = equipped[EquipSlot.back];
    final feetEq = equipped[EquipSlot.feet];
    final accEq = equipped[EquipSlot.accessory];

    final torsoW = s * (0.36 + shoulder * 2);
    final armOut = s * (0.28 + shoulder);

    // Bacaklar
    _rrect(
      canvas,
      Rect.fromLTWH(cx - s * 0.14, s * 0.58, s * 0.1, s * 0.28),
      s * 0.03,
      const Color(0xFF2C3340),
      outline: ink,
      strokeW: sw,
    );
    _rrect(
      canvas,
      Rect.fromLTWH(cx + s * 0.04, s * 0.58, s * 0.1, s * 0.28),
      s * 0.03,
      const Color(0xFF2C3340),
      outline: ink,
      strokeW: sw,
    );

    // Ayakkabı
    final feetKind = gearKindFor(feetEq?.id, EquipSlot.feet);
    final shoeColor = feetEq == null
        ? const Color(0xFF3A3A3A)
        : equipmentColor(feetEq.id, EquipSlot.feet);
    final shoeH = feetKind == GearKind.boot ? s * 0.09 : s * 0.06;
    final shoeAccent = feetEq != null ? const Color(0xFFE07A3D) : null;
    for (final left in [true, false]) {
      final x = left ? cx - s * 0.16 : cx + s * 0.02;
      _rrect(
        canvas,
        Rect.fromLTWH(x, s * 0.82, s * 0.14, shoeH),
        s * 0.02,
        shoeColor,
        outline: ink,
        strokeW: sw,
      );
      if (shoeAccent != null) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x + s * 0.02, s * 0.84, s * 0.1, s * 0.018),
            Radius.circular(s * 0.01),
          ),
          _fill(shoeAccent),
        );
      }
    }

    // Gövde
    final bodyKind = gearKindFor(bodyEq?.id, EquipSlot.body);
    final torsoColor =
        bodyEq == null ? look.shirt : equipmentColor(bodyEq.id, EquipSlot.body);
    final torsoTop = bodyKind == GearKind.hoodie ||
            bodyKind == GearKind.coat ||
            bodyKind == GearKind.vest ||
            bodyKind == GearKind.parka
        ? s * 0.30
        : s * 0.32;
    _rrect(
      canvas,
      Rect.fromLTWH(cx - torsoW / 2, torsoTop, torsoW, s * 0.30),
      s * 0.06,
      torsoColor,
      outline: ink,
      strokeW: sw,
    );

    if (bodyKind == GearKind.vest) {
      canvas.drawLine(
        Offset(cx, torsoTop + s * 0.04),
        Offset(cx, torsoTop + s * 0.26),
        _stroke(ink, sw),
      );
    }

    if (bodyKind == GearKind.hoodie ||
        bodyKind == GearKind.coat ||
        bodyKind == GearKind.parka) {
      final hood = Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(cx, s * 0.26),
            width: s * 0.28,
            height: s * 0.16,
          ),
        );
      canvas.drawPath(hood, _fill(torsoColor.withValues(alpha: 0.85)));
      canvas.drawPath(hood, _stroke(ink, sw));
    }

    // Kollar
    _rrect(
      canvas,
      Rect.fromLTWH(cx - armOut, s * 0.34, s * 0.1, s * 0.22),
      s * 0.04,
      look.skin,
      outline: ink,
      strokeW: sw,
    );
    _rrect(
      canvas,
      Rect.fromLTWH(cx + armOut - s * 0.1, s * 0.34, s * 0.1, s * 0.22),
      s * 0.04,
      look.skin,
      outline: ink,
      strokeW: sw,
    );

    // Eldiven (aksesuar varyantı kol ucunda)
    if (accEq != null &&
        gearKindFor(accEq.id, EquipSlot.accessory) == GearKind.gloves) {
      final gc = equipmentColor(accEq.id, EquipSlot.accessory);
      _rrect(
        canvas,
        Rect.fromLTWH(cx - armOut, s * 0.50, s * 0.1, s * 0.07),
        s * 0.02,
        gc,
        outline: ink,
        strokeW: sw,
      );
      _rrect(
        canvas,
        Rect.fromLTWH(cx + armOut - s * 0.1, s * 0.50, s * 0.1, s * 0.07),
        s * 0.02,
        gc,
        outline: ink,
        strokeW: sw,
      );
    }

    // Sırt çantası
    if (backEq != null) {
      final bagC = equipmentColor(backEq.id, EquipSlot.back);
      final bagKind = gearKindFor(backEq.id, EquipSlot.back);
      final bagW = bagKind == GearKind.duffel ? s * 0.20 : s * 0.16;
      final bagH = bagKind == GearKind.duffel ? s * 0.18 : s * 0.22;
      _rrect(
        canvas,
        Rect.fromLTWH(cx + s * 0.10, s * 0.34, bagW, bagH),
        s * 0.03,
        bagC,
        outline: ink,
        strokeW: sw * 1.2,
      );
      canvas.drawLine(
        Offset(cx + s * 0.02, s * 0.34),
        Offset(cx + s * 0.12, s * 0.38),
        _stroke(ink, sw * 1.4),
      );
      _rrect(
        canvas,
        Rect.fromLTWH(cx + s * 0.13, s * 0.42, s * 0.1, s * 0.08),
        s * 0.015,
        bagC.withValues(alpha: 0.7),
        outline: ink,
        strokeW: sw * 0.8,
      );
    }

    // Kafa
    _circle(
      canvas,
      Offset(cx, s * 0.22),
      s * 0.12,
      look.skin,
      outline: ink,
      strokeW: sw,
    );

    // Saç
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, s * 0.20), radius: s * 0.125),
      3.6,
      2.5,
      true,
      _fill(look.hair),
    );

    // Yüz — baskın zeka ise gözde küçük vurgu
    final eyeFill = auraStat == StatType.intellect && showStatAura
        ? auraColor
        : AppTheme.ink;
    canvas.drawCircle(Offset(cx - s * 0.04, s * 0.21), s * 0.012, _fill(eyeFill));
    canvas.drawCircle(Offset(cx + s * 0.04, s * 0.21), s * 0.012, _fill(eyeFill));
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx, s * 0.245),
        width: s * 0.08,
        height: s * 0.05,
      ),
      0.2,
      2.7,
      false,
      _stroke(AppTheme.ink, s * 0.012)..strokeCap = StrokeCap.round,
    );

    // Baş ekipmanı
    if (headEq != null) {
      final hc = equipmentColor(headEq.id, EquipSlot.head);
      final headKind = gearKindFor(headEq.id, EquipSlot.head);
      switch (headKind) {
        case GearKind.beanie:
          final oval = Rect.fromCenter(
            center: Offset(cx, s * 0.11),
            width: s * 0.26,
            height: s * 0.15,
          );
          canvas.drawOval(oval, _fill(hc));
          canvas.drawOval(oval, _stroke(ink, sw));
          canvas.drawCircle(Offset(cx, s * 0.05), s * 0.03, _fill(AppTheme.signal));
        case GearKind.cap:
          final dome = Rect.fromCenter(
            center: Offset(cx, s * 0.12),
            width: s * 0.28,
            height: s * 0.11,
          );
          canvas.drawOval(dome, _fill(hc));
          canvas.drawOval(dome, _stroke(ink, sw));
          _rrect(
            canvas,
            Rect.fromLTWH(cx - s * 0.02, s * 0.135, s * 0.2, s * 0.04),
            s * 0.01,
            hc,
            outline: ink,
            strokeW: sw,
          );
        case GearKind.bandana:
          _rrect(
            canvas,
            Rect.fromLTWH(cx - s * 0.14, s * 0.11, s * 0.28, s * 0.06),
            s * 0.02,
            hc,
            outline: ink,
            strokeW: sw,
          );
          final tail = Path()
            ..moveTo(cx + s * 0.12, s * 0.14)
            ..lineTo(cx + s * 0.22, s * 0.20)
            ..lineTo(cx + s * 0.10, s * 0.17)
            ..close();
          canvas.drawPath(tail, _fill(hc));
          canvas.drawPath(tail, _stroke(ink, sw * 0.8));
        case GearKind.glasses:
          canvas.drawCircle(
            Offset(cx - s * 0.045, s * 0.21),
            s * 0.035,
            _stroke(hc, sw * 1.4),
          );
          canvas.drawCircle(
            Offset(cx + s * 0.045, s * 0.21),
            s * 0.035,
            _stroke(hc, sw * 1.4),
          );
          canvas.drawLine(
            Offset(cx - s * 0.01, s * 0.21),
            Offset(cx + s * 0.01, s * 0.21),
            _stroke(hc, sw),
          );
        case GearKind.mask:
          _rrect(
            canvas,
            Rect.fromLTWH(cx - s * 0.1, s * 0.22, s * 0.2, s * 0.08),
            s * 0.03,
            hc,
            outline: ink,
            strokeW: sw,
          );
        default:
          _rrect(
            canvas,
            Rect.fromLTWH(cx - s * 0.12, s * 0.10, s * 0.24, s * 0.06),
            s * 0.02,
            hc,
            outline: ink,
            strokeW: sw,
          );
      }
    }

    // Aksesuar (elden / kulak / matara / saat)
    if (accEq != null) {
      final ac = equipmentColor(accEq.id, EquipSlot.accessory);
      final accKind = gearKindFor(accEq.id, EquipSlot.accessory);
      switch (accKind) {
        case GearKind.phones:
          _circle(
            canvas,
            Offset(cx - s * 0.14, s * 0.22),
            s * 0.045,
            ac,
            outline: AppTheme.signal,
            strokeW: sw * 1.3,
          );
          _circle(
            canvas,
            Offset(cx + s * 0.14, s * 0.22),
            s * 0.045,
            ac,
            outline: AppTheme.signal,
            strokeW: sw * 1.3,
          );
          canvas.drawArc(
            Rect.fromCircle(center: Offset(cx, s * 0.17), radius: s * 0.15),
            3.5,
            2.3,
            false,
            _stroke(ac, s * 0.025),
          );
        case GearKind.bottle:
          _rrect(
            canvas,
            Rect.fromLTWH(cx - s * 0.30, s * 0.40, s * 0.07, s * 0.16),
            s * 0.015,
            ac,
            outline: ink,
            strokeW: sw,
          );
          _rrect(
            canvas,
            Rect.fromLTWH(cx - s * 0.285, s * 0.37, s * 0.04, s * 0.04),
            s * 0.01,
            const Color(0xFF2A2F3A),
            outline: ink,
            strokeW: sw * 0.8,
          );
        case GearKind.watch:
          _rrect(
            canvas,
            Rect.fromLTWH(cx - s * 0.28, s * 0.48, s * 0.09, s * 0.055),
            s * 0.012,
            ac,
            outline: ink,
            strokeW: sw,
          );
          canvas.drawCircle(
            Offset(cx - s * 0.235, s * 0.507),
            s * 0.012,
            _fill(AppTheme.ink),
          );
        case GearKind.gloves:
          break;
        default:
          _circle(
            canvas,
            Offset(cx + s * 0.22, s * 0.36),
            s * 0.04,
            ac,
            outline: ink,
            strokeW: sw,
          );
      }
    }

    // Güç omuz vuruşu
    if (showStatAura && auraStat == StatType.strength) {
      canvas.drawCircle(
        Offset(cx - torsoW / 2 - s * 0.02, s * 0.36),
        s * 0.035,
        _fill(auraColor.withValues(alpha: 0.45)),
      );
      canvas.drawCircle(
        Offset(cx + torsoW / 2 + s * 0.02, s * 0.36),
        s * 0.035,
        _fill(auraColor.withValues(alpha: 0.45)),
      );
    }

    canvas.restore();

    if (showLevelBadge) {
      final br = s * 0.09;
      final bx = s * 0.82;
      final by = s * 0.12;
      canvas.drawCircle(Offset(bx, by), br + sw * 1.5, _fill(tier.ringColor));
      canvas.drawCircle(Offset(bx, by), br, _fill(AppTheme.signal));
      canvas.drawCircle(Offset(bx, by), br, _stroke(ink, sw));
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
  bool shouldRepaint(covariant AvatarPainter oldDelegate) {
    return oldDelegate.look != look ||
        oldDelegate.level != level ||
        oldDelegate.strength != strength ||
        oldDelegate.intellect != intellect ||
        oldDelegate.energy != energy ||
        oldDelegate.vitality != vitality ||
        oldDelegate.showLevelBadge != showLevelBadge ||
        oldDelegate.showStatAura != showStatAura ||
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

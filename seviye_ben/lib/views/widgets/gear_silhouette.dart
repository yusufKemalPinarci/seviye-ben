import 'package:flutter/material.dart';

import '../../models/equipment.dart';
import '../../utils/app_theme.dart';
import '../../utils/equipment_look.dart';

/// Envanter satırı için küçük ekipman silueti.
class GearSilhouette extends StatelessWidget {
  const GearSilhouette({
    super.key,
    required this.equipment,
    this.size = 40,
    this.locked = false,
  });

  final Equipment equipment;
  final double size;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final color = locked
        ? AppTheme.onSurfaceMuted.withValues(alpha: 0.45)
        : equipmentColor(equipment.id, equipment.slot);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GearSilhouettePainter(
          kind: gearKindFor(equipment.id, equipment.slot),
          slot: equipment.slot,
          color: color,
          locked: locked,
        ),
      ),
    );
  }
}

class _GearSilhouettePainter extends CustomPainter {
  _GearSilhouettePainter({
    required this.kind,
    required this.slot,
    required this.color,
    required this.locked,
  });

  final GearKind kind;
  final EquipSlot slot;
  final Color color;
  final bool locked;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final fill = Paint()..color = color;
    final stroke = Paint()
      ..color = AppTheme.ink.withValues(alpha: locked ? 0.25 : 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (s * 0.04).clamp(1.0, 1.8);

    void rrect(Rect r, double rad) {
      final rr = RRect.fromRectAndRadius(r, Radius.circular(rad));
      canvas.drawRRect(rr, fill);
      canvas.drawRRect(rr, stroke);
    }

    switch (kind) {
      case GearKind.beanie:
        canvas.drawOval(
          Rect.fromCenter(center: Offset(cx, cy), width: s * 0.72, height: s * 0.55),
          fill,
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset(cx, cy), width: s * 0.72, height: s * 0.55),
          stroke,
        );
      case GearKind.cap:
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(cx, cy - s * 0.05),
            width: s * 0.7,
            height: s * 0.4,
          ),
          fill,
        );
        rrect(
          Rect.fromLTWH(cx - s * 0.05, cy + s * 0.02, s * 0.45, s * 0.14),
          s * 0.04,
        );
      case GearKind.bandana:
        rrect(Rect.fromLTWH(cx - s * 0.35, cy - s * 0.12, s * 0.7, s * 0.24), s * 0.06);
      case GearKind.glasses:
        canvas.drawCircle(Offset(cx - s * 0.16, cy), s * 0.16, stroke);
        canvas.drawCircle(Offset(cx + s * 0.16, cy), s * 0.16, stroke);
        canvas.drawLine(
          Offset(cx - s * 0.02, cy),
          Offset(cx + s * 0.02, cy),
          stroke,
        );
      case GearKind.mask:
        rrect(Rect.fromLTWH(cx - s * 0.32, cy - s * 0.12, s * 0.64, s * 0.28), s * 0.1);
      case GearKind.tee:
      case GearKind.hoodie:
      case GearKind.coat:
      case GearKind.parka:
      case GearKind.vest:
        rrect(Rect.fromLTWH(cx - s * 0.28, cy - s * 0.3, s * 0.56, s * 0.6), s * 0.08);
      case GearKind.bag:
      case GearKind.duffel:
        rrect(Rect.fromLTWH(cx - s * 0.22, cy - s * 0.28, s * 0.44, s * 0.55), s * 0.06);
      case GearKind.sneaker:
      case GearKind.boot:
        rrect(Rect.fromLTWH(cx - s * 0.32, cy - s * 0.1, s * 0.64, s * 0.32), s * 0.08);
      case GearKind.phones:
        canvas.drawCircle(Offset(cx, cy), s * 0.28, fill);
        canvas.drawCircle(Offset(cx, cy), s * 0.28, stroke);
      case GearKind.bottle:
        rrect(Rect.fromLTWH(cx - s * 0.14, cy - s * 0.3, s * 0.28, s * 0.6), s * 0.06);
      case GearKind.watch:
        rrect(Rect.fromLTWH(cx - s * 0.22, cy - s * 0.14, s * 0.44, s * 0.28), s * 0.06);
      case GearKind.gloves:
        rrect(Rect.fromLTWH(cx - s * 0.28, cy - s * 0.18, s * 0.56, s * 0.36), s * 0.1);
      case GearKind.bare:
        switch (slot) {
          case EquipSlot.head:
            canvas.drawCircle(Offset(cx, cy), s * 0.28, fill);
          case EquipSlot.body:
            rrect(
              Rect.fromLTWH(cx - s * 0.28, cy - s * 0.3, s * 0.56, s * 0.6),
              s * 0.08,
            );
          case EquipSlot.back:
            rrect(
              Rect.fromLTWH(cx - s * 0.22, cy - s * 0.28, s * 0.44, s * 0.55),
              s * 0.06,
            );
          case EquipSlot.feet:
            rrect(
              Rect.fromLTWH(cx - s * 0.32, cy - s * 0.1, s * 0.64, s * 0.32),
              s * 0.08,
            );
          case EquipSlot.accessory:
            canvas.drawCircle(Offset(cx, cy), s * 0.22, fill);
        }
    }

    if (locked) {
      final lock = Paint()..color = AppTheme.ink.withValues(alpha: 0.55);
      canvas.drawCircle(Offset(cx, cy + s * 0.06), s * 0.1, lock);
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(cx, cy - s * 0.02),
          width: s * 0.22,
          height: s * 0.2,
        ),
        3.4,
        2.5,
        false,
        Paint()
          ..color = AppTheme.ink.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.06,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GearSilhouettePainter oldDelegate) {
    return oldDelegate.kind != kind ||
        oldDelegate.color != color ||
        oldDelegate.locked != locked ||
        oldDelegate.slot != slot;
  }
}

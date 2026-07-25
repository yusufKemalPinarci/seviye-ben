import 'package:flutter/material.dart';

import '../models/equipment.dart';
import '../utils/app_theme.dart';

class LookStyle {
  const LookStyle({
    required this.id,
    required this.name,
    required this.skin,
    required this.hair,
    required this.shirt,
  });

  final int id;
  final String name;
  final Color skin;
  final Color hair;
  final Color shirt;
}

const lookStyles = [
  LookStyle(
    id: 0,
    name: 'Asfalt Gezgin',
    skin: Color(0xFFC9956C),
    hair: Color(0xFF2A2118),
    shirt: Color(0xFF4A6B5A),
  ),
  LookStyle(
    id: 1,
    name: 'Gece Rüzgarı',
    skin: Color(0xFF8D6E63),
    hair: Color(0xFF1A1A22),
    shirt: Color(0xFF3D4F6F),
  ),
  LookStyle(
    id: 2,
    name: 'Sinyal Tempo',
    skin: Color(0xFFE0A878),
    hair: Color(0xFF4A2C1A),
    shirt: Color(0xFFC45C2A),
  ),
];

LookStyle lookStyleFor(int index) {
  final i = index.clamp(0, lookStyles.length - 1);
  return lookStyles[i];
}

Color equipmentColor(String? equipmentId, EquipSlot slot) {
  switch (equipmentId) {
    case 'eq_bere':
      return const Color(0xFF5C4033);
    case 'eq_siperlik':
      return const Color(0xFF2E4A3E);
    case 'eq_cizgi':
      return AppTheme.signal;
    case 'eq_tisort':
      return const Color(0xFF3D7EA6);
    case 'eq_hoodie':
      return const Color(0xFF2A2F3A);
    case 'eq_sirt_cantasi':
      return const Color(0xFF6B4E31);
    case 'eq_mont':
      return const Color(0xFF1F3A2E);
    case 'eq_spor_ayakkabi':
      return const Color(0xFFE8E4DC);
    case 'eq_trail':
      return const Color(0xFF4A3728);
    case 'eq_kulaklik':
      return AppTheme.ink;
    case 'eq_matara':
      return const Color(0xFF7A8B99);
    case 'eq_saat':
      return AppTheme.signal;
    default:
      switch (slot) {
        case EquipSlot.head:
          return const Color(0xFF6B5B4B);
        case EquipSlot.body:
          return AppTheme.street;
        case EquipSlot.feet:
          return const Color(0xFF3A3A3A);
        case EquipSlot.accessory:
          return AppTheme.signal;
      }
  }
}

enum GearKind { bare, beanie, cap, bandana, tee, hoodie, bag, coat, sneaker, boot, phones, bottle, watch }

GearKind gearKindFor(String? id, EquipSlot slot) {
  switch (id) {
    case 'eq_bere':
      return GearKind.beanie;
    case 'eq_siperlik':
      return GearKind.cap;
    case 'eq_cizgi':
      return GearKind.bandana;
    case 'eq_tisort':
      return GearKind.tee;
    case 'eq_hoodie':
      return GearKind.hoodie;
    case 'eq_sirt_cantasi':
      return GearKind.bag;
    case 'eq_mont':
      return GearKind.coat;
    case 'eq_spor_ayakkabi':
      return GearKind.sneaker;
    case 'eq_trail':
      return GearKind.boot;
    case 'eq_kulaklik':
      return GearKind.phones;
    case 'eq_matara':
      return GearKind.bottle;
    case 'eq_saat':
      return GearKind.watch;
    default:
      return GearKind.bare;
  }
}

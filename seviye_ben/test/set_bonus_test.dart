import 'package:flutter_test/flutter_test.dart';
import 'package:seviye_ben/models/equipment.dart';
import 'package:seviye_ben/models/stat_type.dart';
import 'package:seviye_ben/utils/set_bonus.dart';

void main() {
  const set = EquipmentSet(
    id: 'set_asfalt',
    name: 'Asfalt Takımı',
    pieceIds: ['eq_tisort', 'eq_spor_ayakkabi', 'eq_trail'],
    tiers: [
      SetBonusTier(pieces: 2, stat: StatType.strength, bonus: 2),
    ],
  );

  Equipment piece(String id) => Equipment(
        id: id,
        name: id,
        slot: EquipSlot.body,
        requiredLevel: 1,
        stat: StatType.strength,
        bonus: 1,
        description: '',
        setId: set.id,
      );

  Map<EquipSlot, Equipment?> wear(List<String> ids) {
    final map = <EquipSlot, Equipment?>{
      for (final s in EquipSlot.values) s: null,
    };
    final slots = EquipSlot.values;
    for (var i = 0; i < ids.length && i < slots.length; i++) {
      map[slots[i]] = piece(ids[i]);
    }
    return map;
  }

  test('1 parça set bonusu yok', () {
    final eq = wear(['eq_tisort']);
    expect(setBonusForStat([set], eq, StatType.strength), 0);
  });

  test('2 parça +2 güç (ayakkabı çakışması yüzünden max 2)', () {
    final eq = wear(['eq_tisort', 'eq_spor_ayakkabi']);
    expect(setBonusForStat([set], eq, StatType.strength), 2);
  });

  test('yanlış stata 0', () {
    final eq = wear(['eq_tisort', 'eq_spor_ayakkabi']);
    expect(setBonusForStat([set], eq, StatType.energy), 0);
  });
}

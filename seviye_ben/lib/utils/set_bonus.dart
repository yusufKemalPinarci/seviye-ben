import '../models/equipment.dart';
import '../models/stat_type.dart';

class ActiveSetStatus {
  const ActiveSetStatus({
    required this.set,
    required this.equippedCount,
    this.activeTier,
  });

  final EquipmentSet set;
  final int equippedCount;
  final SetBonusTier? activeTier;

  bool get isActive => activeTier != null;
}

/// Giyilen parçalardan set başına adet.
int countSetPieces(
  EquipmentSet set,
  Map<EquipSlot, Equipment?> equipped,
) {
  final worn = <String>{};
  for (final eq in equipped.values) {
    if (eq != null) {
      worn.add(eq.id);
    }
  }
  var count = 0;
  for (final id in set.pieceIds) {
    if (worn.contains(id)) {
      count++;
    }
  }
  return count;
}

SetBonusTier? bestTierForCount(EquipmentSet set, int count) {
  SetBonusTier? best;
  for (final tier in set.tiers) {
    if (count >= tier.pieces) {
      if (best == null || tier.pieces > best.pieces) {
        best = tier;
      }
    }
  }
  return best;
}

List<ActiveSetStatus> activeSetStatuses(
  List<EquipmentSet> sets,
  Map<EquipSlot, Equipment?> equipped,
) {
  return sets.map((set) {
    final count = countSetPieces(set, equipped);
    return ActiveSetStatus(
      set: set,
      equippedCount: count,
      activeTier: bestTierForCount(set, count),
    );
  }).toList();
}

int setBonusForStat(
  List<EquipmentSet> sets,
  Map<EquipSlot, Equipment?> equipped,
  StatType stat,
) {
  var total = 0;
  for (final status in activeSetStatuses(sets, equipped)) {
    final tier = status.activeTier;
    if (tier != null && tier.stat == stat) {
      total += tier.bonus;
    }
  }
  return total;
}

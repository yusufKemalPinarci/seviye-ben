import 'stat_type.dart';

enum EquipSlot { head, body, back, feet, accessory }

extension EquipSlotLabel on EquipSlot {
  String get labelTr {
    switch (this) {
      case EquipSlot.head:
        return 'Baş';
      case EquipSlot.body:
        return 'Gövde';
      case EquipSlot.back:
        return 'Sırt';
      case EquipSlot.feet:
        return 'Ayak';
      case EquipSlot.accessory:
        return 'Aksesuar';
    }
  }

  static EquipSlot fromKey(String key) {
    return EquipSlot.values.firstWhere(
      (s) => s.name == key,
      orElse: () => EquipSlot.body,
    );
  }
}

class Equipment {
  const Equipment({
    required this.id,
    required this.name,
    required this.slot,
    required this.requiredLevel,
    required this.stat,
    required this.bonus,
    required this.description,
    this.setId,
  });

  final String id;
  final String name;
  final EquipSlot slot;
  final int requiredLevel;
  final StatType stat;
  final int bonus;
  final String description;
  final String? setId;

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'] as String,
      name: json['name'] as String,
      slot: EquipSlotLabel.fromKey(json['slot'] as String),
      requiredLevel: json['requiredLevel'] as int,
      stat: StatTypeLabel.fromKey(json['stat'] as String),
      bonus: json['bonus'] as int,
      description: json['description'] as String? ?? '',
      setId: json['setId'] as String?,
    );
  }
}

class SetBonusTier {
  const SetBonusTier({
    required this.pieces,
    required this.stat,
    required this.bonus,
  });

  final int pieces;
  final StatType stat;
  final int bonus;

  factory SetBonusTier.fromJson(Map<String, dynamic> json) {
    return SetBonusTier(
      pieces: json['pieces'] as int,
      stat: StatTypeLabel.fromKey(json['stat'] as String),
      bonus: json['bonus'] as int,
    );
  }
}

class EquipmentSet {
  const EquipmentSet({
    required this.id,
    required this.name,
    required this.pieceIds,
    required this.tiers,
  });

  final String id;
  final String name;
  final List<String> pieceIds;
  final List<SetBonusTier> tiers;

  factory EquipmentSet.fromJson(Map<String, dynamic> json) {
    return EquipmentSet(
      id: json['id'] as String,
      name: json['name'] as String,
      pieceIds: (json['pieceIds'] as List).map((e) => e.toString()).toList(),
      tiers: (json['tiers'] as List)
          .map((e) => SetBonusTier.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

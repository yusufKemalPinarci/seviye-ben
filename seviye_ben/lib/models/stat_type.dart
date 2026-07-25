enum StatType { strength, intellect, energy, vitality }

extension StatTypeLabel on StatType {
  String get labelTr {
    switch (this) {
      case StatType.strength:
        return 'Güç';
      case StatType.intellect:
        return 'Zeka';
      case StatType.energy:
        return 'Enerji';
      case StatType.vitality:
        return 'Can';
    }
  }

  String get key {
    return name;
  }

  static StatType fromKey(String key) {
    return StatType.values.firstWhere(
      (s) => s.name == key,
      orElse: () => StatType.strength,
    );
  }
}

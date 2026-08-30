import '../../domain/entities/vocabulary_unit_entity.dart';

class VocabularyUnitModel {
  final String level;
  final String unit;
  final String unitName;

  const VocabularyUnitModel({
    required this.level,
    required this.unit,
    required this.unitName,
  });

  factory VocabularyUnitModel.fromJson(Map<String, dynamic> json) {
    return VocabularyUnitModel(
      level: json['level'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      unitName: json['unitName'] as String? ?? '',
    );
  }

  VocabularyUnitEntity toEntity() => VocabularyUnitEntity(level: level, unit: unit, unitName: unitName);
}

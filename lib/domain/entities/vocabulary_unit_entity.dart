import 'package:equatable/equatable.dart';

class VocabularyUnitEntity extends Equatable {
  final String level;
  final String unit;
  final String unitName;

  const VocabularyUnitEntity({
    required this.level,
    required this.unit,
    required this.unitName,
  });

  @override
  List<Object?> get props => [level, unit, unitName];
}

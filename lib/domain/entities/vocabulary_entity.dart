import 'package:equatable/equatable.dart';

class VocabularyEntity extends Equatable {
  /// Stable id within a level: `${unit}-${indexInUnit}` (matches the web app).
  final String id;
  final String hiragana;
  final String kanji;
  final String romanji;
  final String translate;
  final String unit;
  final String unitName;

  const VocabularyEntity({
    required this.id,
    required this.hiragana,
    required this.kanji,
    required this.romanji,
    required this.translate,
    required this.unit,
    required this.unitName,
  });

  @override
  List<Object?> get props => [id, hiragana, kanji, romanji, translate, unit, unitName];
}

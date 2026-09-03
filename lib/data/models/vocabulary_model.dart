import '../../domain/entities/vocabulary_entity.dart';

class VocabularyModel {
  final int no;
  final String hiragana;
  final String kanji;
  final String romanji;
  final String translate;

  const VocabularyModel({
    required this.no,
    required this.hiragana,
    required this.kanji,
    required this.romanji,
    required this.translate,
  });

  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      no: (json['no'] as num?)?.toInt() ?? 0,
      hiragana: json['hiragana'] as String? ?? '',
      kanji: json['kanji'] as String? ?? '',
      romanji: json['romanji'] as String? ?? '',
      translate: json['translate'] as String? ?? '',
    );
  }

  VocabularyEntity toEntity({required String id, required String unit, required String unitName}) {
    return VocabularyEntity(
      id: id,
      hiragana: hiragana,
      kanji: kanji,
      romanji: romanji,
      translate: translate,
      unit: unit,
      unitName: unitName,
    );
  }
}

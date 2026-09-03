import '../../domain/entities/kanji_entity.dart';

class KanjiModel {
  final int id;
  final String kanji;
  final String onyomi;
  final String kunyomi;
  final String hanViet;
  final String meaning;
  final String example;
  final String jlpt;
  final String categoryId;
  final int lesson;

  const KanjiModel({
    required this.id,
    required this.kanji,
    required this.onyomi,
    required this.kunyomi,
    required this.hanViet,
    required this.meaning,
    required this.example,
    required this.jlpt,
    required this.categoryId,
    required this.lesson,
  });

  factory KanjiModel.fromJson(Map<String, dynamic> json) {
    return KanjiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      kanji: json['kanji'] as String? ?? '',
      onyomi: json['onyomi'] as String? ?? '',
      kunyomi: json['kunyomi'] as String? ?? '',
      hanViet: json['hanViet'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      example: json['example'] as String? ?? '',
      jlpt: json['jlpt'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      lesson: (json['lesson'] as num?)?.toInt() ?? 0,
    );
  }

  KanjiEntity toEntity() => KanjiEntity(
    id: id,
    kanji: kanji,
    onyomi: onyomi,
    kunyomi: kunyomi,
    hanViet: hanViet,
    meaning: meaning,
    example: example,
    jlpt: jlpt,
    categoryId: categoryId,
    lesson: lesson,
  );
}

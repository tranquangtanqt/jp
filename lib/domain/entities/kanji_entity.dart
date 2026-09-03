import 'package:equatable/equatable.dart';

class KanjiEntity extends Equatable {
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

  const KanjiEntity({
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

  @override
  List<Object?> get props => [id, kanji, onyomi, kunyomi, hanViet, meaning, example, jlpt, categoryId, lesson];
}

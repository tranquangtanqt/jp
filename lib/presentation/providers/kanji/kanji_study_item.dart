import '../../../domain/entities/kanji_entity.dart';
import '../../../domain/entities/radical_entity.dart';

/// Unified view model so the detail/quiz UI can treat Kanji and radicals the same.
class KanjiStudyItem {
  final String id;
  final String glyph;
  final String hanViet;
  final String meaning;
  final String? onyomi;
  final String? kunyomi;
  final String? example;
  final int? number;
  final int? strokes;

  const KanjiStudyItem({
    required this.id,
    required this.glyph,
    required this.hanViet,
    required this.meaning,
    this.onyomi,
    this.kunyomi,
    this.example,
    this.number,
    this.strokes,
  });

  factory KanjiStudyItem.fromKanji(KanjiEntity e) => KanjiStudyItem(
    id: 'k${e.id}',
    glyph: e.kanji,
    hanViet: e.hanViet,
    meaning: e.meaning,
    onyomi: e.onyomi,
    kunyomi: e.kunyomi,
    example: e.example,
  );

  factory KanjiStudyItem.fromRadical(RadicalEntity e) => KanjiStudyItem(
    id: 'r${e.id}',
    glyph: e.char,
    hanViet: e.hanViet,
    meaning: e.meaning,
    number: e.number,
    strokes: e.strokes,
  );

  bool matches(String keyword) {
    final kw = keyword.trim().toLowerCase();

    if (kw.isEmpty) return true;

    return glyph.contains(kw) || hanViet.toLowerCase().contains(kw) || meaning.toLowerCase().contains(kw);
  }
}

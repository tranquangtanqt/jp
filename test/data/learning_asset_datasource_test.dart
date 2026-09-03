import 'package:flutter_test/flutter_test.dart';
import 'package:nihongo_n5/data/datasources/local/exam_asset_datasource_impl.dart';
import 'package:nihongo_n5/data/datasources/local/kanji_asset_datasource_impl.dart';
import 'package:nihongo_n5/data/datasources/local/vocabulary_asset_datasource_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VocabularyAssetDatasourceImpl', () {
    final datasource = VocabularyAssetDatasourceImpl();

    test('loads the 25 N5 units', () async {
      final units = await datasource.getUnits('N5');

      expect(units.length, 25);
      expect(units.first.unitName, 'Bài 1');
    });

    test('builds vocabulary rows with stable ids', () async {
      final vocab = await datasource.getVocabularyByLevel('N5');

      expect(vocab, isNotEmpty);
      expect(vocab.first.id, startsWith('unit_1-'));
      expect(vocab.every((v) => v.hiragana.isNotEmpty), isTrue);
    });

    test('returns empty for a level without data', () async {
      expect(await datasource.getVocabularyByLevel('N4'), isEmpty);
    });
  });

  group('KanjiAssetDatasourceImpl', () {
    final datasource = KanjiAssetDatasourceImpl();

    test('loads 214 radicals', () async {
      final radicals = await datasource.getRadicals();

      expect(radicals.length, 214);
    });

    test('loads N5 kanji', () async {
      final kanji = await datasource.getKanjiByCategory('n5');

      expect(kanji, isNotEmpty);
      expect(kanji.every((k) => k.categoryId == 'n5'), isTrue);
    });

    test('exposes three categories', () async {
      final categories = await datasource.getCategories();

      expect(categories.map((c) => c.id), containsAll(['radicals', 'n5', 'n4']));
    });
  });

  group('ExamAssetDatasourceImpl', () {
    final datasource = ExamAssetDatasourceImpl();

    test('lesson 1 has questions', () async {
      final lesson = await datasource.getLesson(1);

      expect(lesson, isNotNull);
      expect(lesson!.questions, isNotEmpty);
      expect(lesson.questions.first.options, isNotEmpty);
    });

    test('reports 25 available lessons', () async {
      final lessons = await datasource.getAvailableLessons();

      expect(lessons.length, 25);
    });
  });
}

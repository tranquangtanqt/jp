import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nihongo_n5/app/di/app_providers.dart';
import 'package:nihongo_n5/core/services/database/database_service.dart';
import 'package:nihongo_n5/presentation/providers/exam/exam_lessons_notifier.dart';
import 'package:nihongo_n5/presentation/providers/exam/exam_quiz_notifier.dart';
import 'package:nihongo_n5/presentation/providers/exam/exam_quiz_state.dart';
import 'package:nihongo_n5/presentation/providers/kanji/kanji_categories_notifier.dart';
import 'package:nihongo_n5/presentation/providers/kanji/kanji_detail_notifier.dart';
import 'package:nihongo_n5/presentation/providers/kanji/kanji_quiz_notifier.dart';
import 'package:nihongo_n5/presentation/providers/kanji/kanji_quiz_state.dart';
import 'package:nihongo_n5/presentation/providers/vocabulary/vocabulary_detail_notifier.dart';
import 'package:nihongo_n5/presentation/providers/vocabulary/vocabulary_levels_notifier.dart';
import 'package:nihongo_n5/presentation/providers/vocabulary/vocabulary_quiz_notifier.dart';
import 'package:nihongo_n5/presentation/providers/vocabulary/vocabulary_quiz_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await DatabaseService.instance.initTestDatabase(testDatabase: db);

    container = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
  });

  tearDown(() => container.dispose());

  T keepAlive<T>(ProviderListenable<T> provider) {
    container.listen(provider, (_, _) {});

    return container.read(provider);
  }

  group('Vocabulary', () {
    test('levels notifier counts N5 vocabulary', () async {
      keepAlive(vocabularyLevelsNotifierProvider);
      await container.read(vocabularyLevelsNotifierProvider.notifier).load();

      expect(container.read(vocabularyLevelsNotifierProvider).counts['N5'], greaterThan(400));
    });

    test('detail notifier loads, filters by keyword and unit', () async {
      keepAlive(vocabularyDetailNotifierProvider('N5'));
      final notifier = container.read(vocabularyDetailNotifierProvider('N5').notifier);
      await notifier.load();

      final state = container.read(vocabularyDetailNotifierProvider('N5'));
      expect(state.units.length, 25);
      expect(state.all, isNotEmpty);

      notifier.setUnitFilter('unit_1');
      expect(
        container.read(vocabularyDetailNotifierProvider('N5')).filtered.every((v) => v.unit == 'unit_1'),
        isTrue,
      );
    });

    test('quiz builds questions and records progress', () async {
      const arg = (level: 'N5', mistakeMode: false);
      keepAlive(vocabularyQuizNotifierProvider(arg));
      final notifier = container.read(vocabularyQuizNotifierProvider(arg).notifier);
      await notifier.load();

      notifier.toggleUnit('unit_1');
      notifier.toggleUnit('unit_2');
      notifier.start();

      var state = container.read(vocabularyQuizNotifierProvider(arg));
      expect(state.phase, QuizPhase.playing);
      expect(state.questions, isNotEmpty);

      // Answer the first two questions incorrectly.
      for (var i = 0; i < 2; i++) {
        final question = container.read(vocabularyQuizNotifierProvider(arg)).currentQuestion!;
        final wrong = question.choices.firstWhere((c) => c.id != question.target.id);
        await notifier.submit(wrong);
        notifier.next();
      }

      state = container.read(vocabularyQuizNotifierProvider(arg));
      expect(state.wrongCount, 2);

      // The wrong answers are now reviewable in mistake mode.
      const mistakeArg = (level: 'N5', mistakeMode: true);
      keepAlive(vocabularyQuizNotifierProvider(mistakeArg));
      await container.read(vocabularyQuizNotifierProvider(mistakeArg).notifier).load();
      final mistakeState = container.read(vocabularyQuizNotifierProvider(mistakeArg));
      expect(mistakeState.error, isNull);
      expect(mistakeState.phase, QuizPhase.playing);
    });
  });

  group('Exam', () {
    test('lessons notifier reports 25 available lessons', () async {
      keepAlive(examLessonsNotifierProvider);
      await container.read(examLessonsNotifierProvider.notifier).load();

      final state = container.read(examLessonsNotifierProvider);
      expect(state.available.length, 25);
      expect(state.questionCounts[1], greaterThan(0));
    });

    test('quiz runs to completion and stores best score', () async {
      const arg = (lesson: 1, mistakeMode: false);
      keepAlive(examQuizNotifierProvider(arg));
      final notifier = container.read(examQuizNotifierProvider(arg).notifier);
      await notifier.load();

      notifier.setCount(10);
      notifier.start();

      for (var i = 0; i < 10; i++) {
        final q = container.read(examQuizNotifierProvider(arg)).currentQuestion!;
        await notifier.submit(q.answerIndex);
        await notifier.next();
      }

      final state = container.read(examQuizNotifierProvider(arg));
      expect(state.phase, ExamQuizPhase.finished);
      expect(state.correctCount, 10);

      final saved = await container.read(progressRepositoryProvider).getExamProgress(1);
      expect(saved.data?.correct, 10);
      expect(saved.data?.total, 10);
    });
  });

  group('Kanji', () {
    test('categories notifier counts radicals and N5 kanji', () async {
      keepAlive(kanjiCategoriesNotifierProvider);
      await container.read(kanjiCategoriesNotifierProvider.notifier).load();

      final state = container.read(kanjiCategoriesNotifierProvider);
      expect(state.counts['radicals'], 214);
      expect(state.counts['n5'], greaterThan(0));
    });

    test('detail notifier loads radicals', () async {
      keepAlive(kanjiDetailNotifierProvider('radicals'));
      await container.read(kanjiDetailNotifierProvider('radicals').notifier).load();

      expect(container.read(kanjiDetailNotifierProvider('radicals')).all.length, 214);
    });

    test('quiz builds questions for N5 kanji', () async {
      const arg = (categoryId: 'n5', mistakeMode: false);
      keepAlive(kanjiQuizNotifierProvider(arg));
      final notifier = container.read(kanjiQuizNotifierProvider(arg).notifier);
      await notifier.load();
      notifier.start();

      final state = container.read(kanjiQuizNotifierProvider(arg));
      expect(state.phase, KanjiQuizPhase.playing);
      expect(state.questions.length, 10);
      expect(state.currentQuestion!.choices, contains(state.currentQuestion!.target));
    });
  });
}

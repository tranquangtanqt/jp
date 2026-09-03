import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../../../core/utilities/quiz_engine.dart';
import '../../../domain/entities/learning_progress_entity.dart';
import '../../../domain/usecases/kanji_usecases.dart';
import '../../../domain/usecases/params/no_param.dart';
import '../../../domain/usecases/progress_usecases.dart';
import 'kanji_quiz_state.dart';
import 'kanji_study_item.dart';

typedef KanjiQuizArg = ({String categoryId, bool mistakeMode});

final kanjiQuizNotifierProvider = AutoDisposeNotifierProvider.family<KanjiQuizNotifier, KanjiQuizState, KanjiQuizArg>(
  KanjiQuizNotifier.new,
);

class KanjiQuizNotifier extends AutoDisposeFamilyNotifier<KanjiQuizState, KanjiQuizArg> {
  static const _quizLength = 10;

  List<KanjiStudyItem> _all = const [];

  String get _categoryId => arg.categoryId;

  @override
  KanjiQuizState build(KanjiQuizArg arg) => KanjiQuizState(mistakeMode: arg.mistakeMode);

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final kanjiRepo = ref.read(kanjiRepositoryProvider);

    if (_categoryId == 'radicals') {
      final res = await GetRadicalsUsecase(kanjiRepo).call(const NoParam());
      _all = (res.data ?? []).map(KanjiStudyItem.fromRadical).toList();
    } else {
      final res = await GetKanjiByCategoryUsecase(kanjiRepo).call(_categoryId);
      _all = (res.data ?? []).map(KanjiStudyItem.fromKanji).toList();
    }

    if (_all.length < 2) {
      state = state.copyWith(isLoading: false, error: 'Không đủ dữ liệu để làm trắc nghiệm.');

      return;
    }

    final progress = await GetProgressUsecase(
      ref.read(progressRepositoryProvider),
    ).call((feature: ProgressFeature.kanji, scope: _categoryId));
    final mastered = progress.data?.masteredIds ?? <String>{};

    if (arg.mistakeMode) {
      final mistakeIds = progress.data?.mistakeIds ?? <String>{};
      final pool = _all.where((item) => mistakeIds.contains(item.id)).toList();

      if (pool.length < 2) {
        state = state.copyWith(isLoading: false, error: 'Chưa có đủ câu sai để ôn tập (cần ít nhất 2 câu).');

        return;
      }

      state = state.copyWith(
        isLoading: false,
        phase: KanjiQuizPhase.playing,
        pool: pool,
        masteredIds: mastered,
        questions: _build(pool, state.choiceCount, state.direction),
      );

      return;
    }

    state = state.copyWith(isLoading: false, masteredIds: mastered);
  }

  void setChoiceCount(int value) => state = state.copyWith(choiceCount: value);

  void setDirection(KanjiQuizDirection value) => state = state.copyWith(direction: value);

  void start() {
    state = state.copyWith(
      phase: KanjiQuizPhase.playing,
      pool: _all,
      questions: _build(_all, state.choiceCount, state.direction),
      currentIndex: 0,
      isAnswered: false,
      isCorrect: false,
      clearSelectedChoice: true,
      correctCount: 0,
      wrongCount: 0,
      clearError: true,
    );
  }

  Future<void> submit(KanjiStudyItem choice) async {
    final question = state.currentQuestion;

    if (state.isAnswered || question == null) return;

    final correct = choice.id == question.target.id;

    state = state.copyWith(
      isAnswered: true,
      isCorrect: correct,
      selectedChoiceId: choice.id,
      correctCount: correct ? state.correctCount + 1 : state.correctCount,
      wrongCount: correct ? state.wrongCount : state.wrongCount + 1,
    );

    final progressRepo = ref.read(progressRepositoryProvider);

    if (correct) {
      await RecordMasteredUsecase(
        progressRepo,
      ).call((feature: ProgressFeature.kanji, scope: _categoryId, itemId: question.target.id));
      state = state.copyWith(masteredIds: {...state.masteredIds, question.target.id});
    }

    await RecordAnswerUsecase(
      progressRepo,
    ).call((feature: ProgressFeature.kanji, scope: _categoryId, itemId: question.target.id, correct: correct));
  }

  void next() {
    final atEnd = state.currentIndex + 1 >= state.questions.length;

    state = state.copyWith(
      questions: atEnd ? _build(state.pool, state.choiceCount, state.direction) : state.questions,
      currentIndex: atEnd ? 0 : state.currentIndex + 1,
      isAnswered: false,
      isCorrect: false,
      clearSelectedChoice: true,
    );
  }

  Future<void> clearProgress() async {
    await ClearMasteredUsecase(
      ref.read(progressRepositoryProvider),
    ).call((feature: ProgressFeature.kanji, scope: _categoryId));
    state = state.copyWith(masteredIds: {});
  }

  List<KanjiQuizQuestion> _build(List<KanjiStudyItem> pool, int choiceCount, KanjiQuizDirection mode) {
    final targets = shuffled(pool).take(_quizLength < pool.length ? _quizLength : pool.length);

    return targets.map((target) {
      final distractors = pickDistractors<KanjiStudyItem>(pool, (e) => e.id == target.id, choiceCount - 1);

      return KanjiQuizQuestion(
        target: target,
        choices: shuffled([target, ...distractors]),
        direction: _pickDirection(mode),
      );
    }).toList();
  }

  KanjiQuestionDirection _pickDirection(KanjiQuizDirection mode) {
    return switch (mode) {
      KanjiQuizDirection.glyphToMeaning => KanjiQuestionDirection.glyphToMeaning,
      KanjiQuizDirection.meaningToGlyph => KanjiQuestionDirection.meaningToGlyph,
      KanjiQuizDirection.mixed => shuffled(
        const [KanjiQuestionDirection.glyphToMeaning, KanjiQuestionDirection.meaningToGlyph],
      ).first,
    };
  }
}

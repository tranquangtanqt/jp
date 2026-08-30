import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../../../core/utilities/quiz_engine.dart';
import '../../../domain/entities/learning_progress_entity.dart';
import '../../../domain/entities/vocabulary_entity.dart';
import '../../../domain/usecases/progress_usecases.dart';
import '../../../domain/usecases/vocabulary_usecases.dart';
import 'vocabulary_quiz_state.dart';

typedef VocabularyQuizArg = ({String level, bool mistakeMode});

final vocabularyQuizNotifierProvider =
    AutoDisposeNotifierProvider.family<VocabularyQuizNotifier, VocabularyQuizState, VocabularyQuizArg>(
      VocabularyQuizNotifier.new,
    );

class VocabularyQuizNotifier extends AutoDisposeFamilyNotifier<VocabularyQuizState, VocabularyQuizArg> {
  static const _quizLength = 10;

  List<VocabularyEntity> _allVocab = const [];

  String get _level => arg.level;

  @override
  VocabularyQuizState build(VocabularyQuizArg arg) => VocabularyQuizState(mistakeMode: arg.mistakeMode);

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final vocabRepo = ref.read(vocabularyRepositoryProvider);
    final unitsRes = await GetVocabularyUnitsUsecase(vocabRepo).call(_level);
    final vocabRes = await GetVocabularyByLevelUsecase(vocabRepo).call(_level);

    if (vocabRes.isFailure) {
      state = state.copyWith(isLoading: false, error: vocabRes.message ?? 'Không tải được từ vựng');

      return;
    }

    _allVocab = vocabRes.data ?? [];

    final progressRes = await GetProgressUsecase(
      ref.read(progressRepositoryProvider),
    ).call((feature: ProgressFeature.vocabulary, scope: _level));
    final mastered = progressRes.data?.masteredIds ?? <String>{};

    if (arg.mistakeMode) {
      final mistakeIds = progressRes.data?.mistakeIds ?? <String>{};
      final pool = _allVocab.where((item) => mistakeIds.contains(item.id)).toList();

      if (pool.length < 2) {
        state = state.copyWith(isLoading: false, error: 'Chưa có đủ câu sai để ôn tập (cần ít nhất 2 câu).');

        return;
      }

      state = state.copyWith(
        isLoading: false,
        phase: QuizPhase.playing,
        pool: pool,
        masteredIds: mastered,
        questions: _buildQuestions(pool, state.choiceCount, state.direction),
      );

      return;
    }

    state = state.copyWith(isLoading: false, units: unitsRes.data ?? [], masteredIds: mastered);
  }

  void toggleUnit(String unit) {
    final next = Set<String>.of(state.selectedUnits);
    next.contains(unit) ? next.remove(unit) : next.add(unit);
    state = state.copyWith(selectedUnits: next);
  }

  void setChoiceCount(int value) => state = state.copyWith(choiceCount: value);

  void setDirection(QuizDirection value) => state = state.copyWith(direction: value);

  void start() {
    if (state.selectedUnits.isEmpty) return;

    final pool = _allVocab.where((item) => state.selectedUnits.contains(item.unit)).toList();

    if (pool.length < 2) {
      state = state.copyWith(error: 'Bài đã chọn không đủ từ vựng để làm trắc nghiệm.');

      return;
    }

    state = state.copyWith(
      phase: QuizPhase.playing,
      pool: pool,
      questions: _buildQuestions(pool, state.choiceCount, state.direction),
      currentIndex: 0,
      isAnswered: false,
      isCorrect: false,
      showChoices: false,
      clearSelectedChoice: true,
      correctCount: 0,
      wrongCount: 0,
      clearError: true,
    );
  }

  void reveal() => state = state.copyWith(showChoices: true);

  Future<void> submit(VocabularyEntity choice) async {
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
      ).call((feature: ProgressFeature.vocabulary, scope: _level, itemId: question.target.id));
      state = state.copyWith(masteredIds: {...state.masteredIds, question.target.id});
    }

    await RecordAnswerUsecase(
      progressRepo,
    ).call((feature: ProgressFeature.vocabulary, scope: _level, itemId: question.target.id, correct: correct));
  }

  void next() {
    final atEnd = state.currentIndex + 1 >= state.questions.length;

    state = state.copyWith(
      questions: atEnd ? _buildQuestions(state.pool, state.choiceCount, state.direction) : state.questions,
      currentIndex: atEnd ? 0 : state.currentIndex + 1,
      isAnswered: false,
      isCorrect: false,
      showChoices: false,
      clearSelectedChoice: true,
    );
  }

  Future<void> clearProgress() async {
    await ClearMasteredUsecase(
      ref.read(progressRepositoryProvider),
    ).call((feature: ProgressFeature.vocabulary, scope: _level));
    state = state.copyWith(masteredIds: {});
  }

  List<VocabularyQuizQuestion> _buildQuestions(List<VocabularyEntity> pool, int choiceCount, QuizDirection mode) {
    final targets = shuffled(pool).take(_quizLength < pool.length ? _quizLength : pool.length);

    return targets.map((target) {
      final distractors = pickDistractors<VocabularyEntity>(pool, (e) => e.id == target.id, choiceCount - 1);

      return VocabularyQuizQuestion(
        target: target,
        choices: shuffled([target, ...distractors]),
        direction: _pickDirection(mode),
      );
    }).toList();
  }

  QuestionDirection _pickDirection(QuizDirection mode) {
    return switch (mode) {
      QuizDirection.viJa => QuestionDirection.viJa,
      QuizDirection.jaVi => QuestionDirection.jaVi,
      QuizDirection.mixed => shuffled(const [QuestionDirection.viJa, QuestionDirection.jaVi]).first,
    };
  }
}

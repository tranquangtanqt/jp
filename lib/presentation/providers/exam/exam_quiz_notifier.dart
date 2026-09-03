import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../../../core/utilities/quiz_engine.dart';
import '../../../domain/entities/exam_question_entity.dart';
import '../../../domain/entities/learning_progress_entity.dart';
import '../../../domain/usecases/exam_usecases.dart';
import '../../../domain/usecases/progress_usecases.dart';
import 'exam_quiz_state.dart';

typedef ExamQuizArg = ({int lesson, bool mistakeMode});

final examQuizNotifierProvider = AutoDisposeNotifierProvider.family<ExamQuizNotifier, ExamQuizState, ExamQuizArg>(
  ExamQuizNotifier.new,
);

class ExamQuizNotifier extends AutoDisposeFamilyNotifier<ExamQuizState, ExamQuizArg> {
  List<ExamQuestionEntity> _all = const [];

  int get _lesson => arg.lesson;

  String get _scope => _lesson.toString();

  @override
  ExamQuizState build(ExamQuizArg arg) => ExamQuizState(mistakeMode: arg.mistakeMode);

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final lessonRes = await GetExamLessonUsecase(ref.read(examRepositoryProvider)).call(_lesson);

    if (lessonRes.isFailure || lessonRes.data == null) {
      state = state.copyWith(isLoading: false, error: lessonRes.message ?? 'Không tải được đề');

      return;
    }

    _all = lessonRes.data!.questions;
    final types = _all.map((q) => q.type).toSet();

    final examProgress = await GetExamProgressUsecase(ref.read(progressRepositoryProvider)).call(_lesson);
    final progress = await GetProgressUsecase(
      ref.read(progressRepositoryProvider),
    ).call((feature: ProgressFeature.exam, scope: _scope));
    final mastered = progress.data?.masteredIds ?? <String>{};

    if (arg.mistakeMode) {
      final mistakeIds = progress.data?.mistakeIds ?? <String>{};
      final pool = _all.where((q) => mistakeIds.contains(q.id.toString())).toList();

      if (pool.isEmpty) {
        state = state.copyWith(isLoading: false, error: 'Chưa có câu sai nào để ôn tập.');

        return;
      }

      state = state.copyWith(
        isLoading: false,
        phase: ExamQuizPhase.playing,
        availableTypes: types,
        questions: _build(pool, pool.length),
        pool: pool,
        masteredIds: mastered,
        bestCorrect: examProgress.data?.correct ?? 0,
        bestTotal: examProgress.data?.total ?? 0,
      );

      return;
    }

    state = state.copyWith(
      isLoading: false,
      availableTypes: types,
      masteredIds: mastered,
      bestCorrect: examProgress.data?.correct ?? 0,
      bestTotal: examProgress.data?.total ?? 0,
    );
  }

  void toggleType(String type) {
    final next = Set<String>.of(state.typeFilter);
    next.contains(type) ? next.remove(type) : next.add(type);
    state = state.copyWith(typeFilter: next);
  }

  void setCount(int value) => state = state.copyWith(questionCount: value);

  void toggleOnlyNotDone() => state = state.copyWith(onlyNotDone: !state.onlyNotDone);

  void start() {
    var filtered = state.typeFilter.isEmpty ? _all : _all.where((q) => state.typeFilter.contains(q.type)).toList();

    if (state.onlyNotDone) {
      filtered = filtered.where((q) => !state.masteredIds.contains(q.id.toString())).toList();
    }

    if (filtered.isEmpty) {
      state = state.copyWith(error: 'Không có câu hỏi phù hợp bộ lọc.');

      return;
    }

    state = state.copyWith(
      phase: ExamQuizPhase.playing,
      questions: _build(filtered, state.questionCount),
      pool: filtered,
      currentIndex: 0,
      isAnswered: false,
      clearSelected: true,
      correctCount: 0,
      wrongCount: 0,
      clearError: true,
    );
  }

  Future<void> submit(int index) async {
    final question = state.currentQuestion;

    if (state.isAnswered || question == null) return;

    final correct = index == question.answerIndex;

    state = state.copyWith(
      isAnswered: true,
      selectedIndex: index,
      correctCount: correct ? state.correctCount + 1 : state.correctCount,
      wrongCount: correct ? state.wrongCount : state.wrongCount + 1,
    );

    final progressRepo = ref.read(progressRepositoryProvider);
    final itemId = question.source.id.toString();

    if (correct) {
      await RecordMasteredUsecase(progressRepo).call((feature: ProgressFeature.exam, scope: _scope, itemId: itemId));
      state = state.copyWith(masteredIds: {...state.masteredIds, itemId});
    }

    await RecordAnswerUsecase(
      progressRepo,
    ).call((feature: ProgressFeature.exam, scope: _scope, itemId: itemId, correct: correct));
  }

  Future<void> next() async {
    if (state.currentIndex + 1 >= state.questions.length) {
      await _finish();

      return;
    }

    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      isAnswered: false,
      clearSelected: true,
    );
  }

  Future<void> _finish() async {
    final total = state.questions.length;
    final correct = state.correctCount;
    final keepBest = state.bestTotal > 0 && state.bestCorrect / state.bestTotal >= correct / total;

    if (!keepBest) {
      await SaveExamProgressUsecase(
        ref.read(progressRepositoryProvider),
      ).call((lesson: _lesson, correct: correct, total: total));
    }

    state = state.copyWith(
      phase: ExamQuizPhase.finished,
      bestCorrect: keepBest ? state.bestCorrect : correct,
      bestTotal: keepBest ? state.bestTotal : total,
    );
  }

  void restart() {
    state = state.copyWith(
      phase: ExamQuizPhase.setup,
      questions: const [],
      currentIndex: 0,
      isAnswered: false,
      clearSelected: true,
      correctCount: 0,
      clearError: true,
    );
  }

  List<ExamPlayQuestion> _build(List<ExamQuestionEntity> pool, int count) {
    final valid = pool.where((q) => q.options.length >= 2 && q.answer >= 0 && q.answer < q.options.length).toList();
    final take = count < valid.length ? count : valid.length;

    return shuffled(valid).take(take).map((source) {
      final correctText = source.options[source.answer];
      final options = shuffled(source.options);

      return ExamPlayQuestion(source: source, options: options, answerIndex: options.indexOf(correctText));
    }).toList();
  }
}

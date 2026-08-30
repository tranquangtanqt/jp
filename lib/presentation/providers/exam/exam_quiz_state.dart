import '../../../domain/entities/exam_question_entity.dart';

enum ExamQuizPhase { setup, playing, finished }

class ExamPlayQuestion {
  final ExamQuestionEntity source;
  final List<String> options;
  final int answerIndex;

  const ExamPlayQuestion({
    required this.source,
    required this.options,
    required this.answerIndex,
  });
}

class ExamQuizState {
  final ExamQuizPhase phase;
  final bool isLoading;
  final String? error;
  final bool mistakeMode;

  final Set<String> availableTypes;
  final Set<String> typeFilter;
  final int questionCount;

  final List<ExamPlayQuestion> questions;
  final int currentIndex;
  final bool isAnswered;
  final int? selectedIndex;
  final int correctCount;

  final int bestCorrect;
  final int bestTotal;

  const ExamQuizState({
    this.phase = ExamQuizPhase.setup,
    this.isLoading = false,
    this.error,
    this.mistakeMode = false,
    this.availableTypes = const {},
    this.typeFilter = const {},
    this.questionCount = 10,
    this.questions = const [],
    this.currentIndex = 0,
    this.isAnswered = false,
    this.selectedIndex,
    this.correctCount = 0,
    this.bestCorrect = 0,
    this.bestTotal = 0,
  });

  ExamPlayQuestion? get currentQuestion => currentIndex < questions.length ? questions[currentIndex] : null;

  ExamQuizState copyWith({
    ExamQuizPhase? phase,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? mistakeMode,
    Set<String>? availableTypes,
    Set<String>? typeFilter,
    int? questionCount,
    List<ExamPlayQuestion>? questions,
    int? currentIndex,
    bool? isAnswered,
    int? selectedIndex,
    bool clearSelected = false,
    int? correctCount,
    int? bestCorrect,
    int? bestTotal,
  }) {
    return ExamQuizState(
      phase: phase ?? this.phase,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      mistakeMode: mistakeMode ?? this.mistakeMode,
      availableTypes: availableTypes ?? this.availableTypes,
      typeFilter: typeFilter ?? this.typeFilter,
      questionCount: questionCount ?? this.questionCount,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      isAnswered: isAnswered ?? this.isAnswered,
      selectedIndex: clearSelected ? null : (selectedIndex ?? this.selectedIndex),
      correctCount: correctCount ?? this.correctCount,
      bestCorrect: bestCorrect ?? this.bestCorrect,
      bestTotal: bestTotal ?? this.bestTotal,
    );
  }
}

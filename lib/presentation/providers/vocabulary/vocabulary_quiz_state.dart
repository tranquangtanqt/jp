import '../../../domain/entities/vocabulary_entity.dart';
import '../../../domain/entities/vocabulary_unit_entity.dart';

enum QuizPhase { setup, playing }

enum QuizDirection { viJa, jaVi, mixed }

enum QuestionDirection { viJa, jaVi }

class VocabularyQuizQuestion {
  final VocabularyEntity target;
  final List<VocabularyEntity> choices;
  final QuestionDirection direction;

  const VocabularyQuizQuestion({
    required this.target,
    required this.choices,
    required this.direction,
  });
}

class VocabularyQuizState {
  final QuizPhase phase;
  final bool isLoading;
  final String? error;

  final List<VocabularyUnitEntity> units;
  final Set<String> selectedUnits;
  final int choiceCount;
  final QuizDirection direction;
  final bool mistakeMode;

  final List<VocabularyEntity> pool;
  final List<VocabularyQuizQuestion> questions;
  final int currentIndex;

  final bool isAnswered;
  final bool isCorrect;
  final bool showChoices;
  final String? selectedChoiceId;
  final int correctCount;
  final int wrongCount;

  final Set<String> masteredIds;

  const VocabularyQuizState({
    this.phase = QuizPhase.setup,
    this.isLoading = false,
    this.error,
    this.units = const [],
    this.selectedUnits = const {},
    this.choiceCount = 4,
    this.direction = QuizDirection.mixed,
    this.mistakeMode = false,
    this.pool = const [],
    this.questions = const [],
    this.currentIndex = 0,
    this.isAnswered = false,
    this.isCorrect = false,
    this.showChoices = false,
    this.selectedChoiceId,
    this.correctCount = 0,
    this.wrongCount = 0,
    this.masteredIds = const {},
  });

  VocabularyQuizQuestion? get currentQuestion => currentIndex < questions.length ? questions[currentIndex] : null;

  int get scopeMastered => pool.where((item) => masteredIds.contains(item.id)).length;

  VocabularyQuizState copyWith({
    QuizPhase? phase,
    bool? isLoading,
    String? error,
    bool clearError = false,
    List<VocabularyUnitEntity>? units,
    Set<String>? selectedUnits,
    int? choiceCount,
    QuizDirection? direction,
    bool? mistakeMode,
    List<VocabularyEntity>? pool,
    List<VocabularyQuizQuestion>? questions,
    int? currentIndex,
    bool? isAnswered,
    bool? isCorrect,
    bool? showChoices,
    String? selectedChoiceId,
    bool clearSelectedChoice = false,
    int? correctCount,
    int? wrongCount,
    Set<String>? masteredIds,
  }) {
    return VocabularyQuizState(
      phase: phase ?? this.phase,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      units: units ?? this.units,
      selectedUnits: selectedUnits ?? this.selectedUnits,
      choiceCount: choiceCount ?? this.choiceCount,
      direction: direction ?? this.direction,
      mistakeMode: mistakeMode ?? this.mistakeMode,
      pool: pool ?? this.pool,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      isAnswered: isAnswered ?? this.isAnswered,
      isCorrect: isCorrect ?? this.isCorrect,
      showChoices: showChoices ?? this.showChoices,
      selectedChoiceId: clearSelectedChoice ? null : (selectedChoiceId ?? this.selectedChoiceId),
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      masteredIds: masteredIds ?? this.masteredIds,
    );
  }
}

import 'kanji_study_item.dart';

enum KanjiQuizPhase { setup, playing }

enum KanjiQuizDirection { glyphToMeaning, meaningToGlyph, mixed }

enum KanjiQuestionDirection { glyphToMeaning, meaningToGlyph }

class KanjiQuizQuestion {
  final KanjiStudyItem target;
  final List<KanjiStudyItem> choices;
  final KanjiQuestionDirection direction;

  const KanjiQuizQuestion({required this.target, required this.choices, required this.direction});
}

class KanjiQuizState {
  final KanjiQuizPhase phase;
  final bool isLoading;
  final String? error;
  final bool mistakeMode;

  final int choiceCount;
  final KanjiQuizDirection direction;

  final List<KanjiStudyItem> pool;
  final List<KanjiQuizQuestion> questions;
  final int currentIndex;
  final bool isAnswered;
  final bool isCorrect;
  final String? selectedChoiceId;
  final int correctCount;
  final int wrongCount;
  final Set<String> masteredIds;

  const KanjiQuizState({
    this.phase = KanjiQuizPhase.setup,
    this.isLoading = false,
    this.error,
    this.mistakeMode = false,
    this.choiceCount = 4,
    this.direction = KanjiQuizDirection.mixed,
    this.pool = const [],
    this.questions = const [],
    this.currentIndex = 0,
    this.isAnswered = false,
    this.isCorrect = false,
    this.selectedChoiceId,
    this.correctCount = 0,
    this.wrongCount = 0,
    this.masteredIds = const {},
  });

  KanjiQuizQuestion? get currentQuestion => currentIndex < questions.length ? questions[currentIndex] : null;

  int get scopeMastered => pool.where((item) => masteredIds.contains(item.id)).length;

  KanjiQuizState copyWith({
    KanjiQuizPhase? phase,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? mistakeMode,
    int? choiceCount,
    KanjiQuizDirection? direction,
    List<KanjiStudyItem>? pool,
    List<KanjiQuizQuestion>? questions,
    int? currentIndex,
    bool? isAnswered,
    bool? isCorrect,
    String? selectedChoiceId,
    bool clearSelectedChoice = false,
    int? correctCount,
    int? wrongCount,
    Set<String>? masteredIds,
  }) {
    return KanjiQuizState(
      phase: phase ?? this.phase,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      mistakeMode: mistakeMode ?? this.mistakeMode,
      choiceCount: choiceCount ?? this.choiceCount,
      direction: direction ?? this.direction,
      pool: pool ?? this.pool,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      isAnswered: isAnswered ?? this.isAnswered,
      isCorrect: isCorrect ?? this.isCorrect,
      selectedChoiceId: clearSelectedChoice ? null : (selectedChoiceId ?? this.selectedChoiceId),
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      masteredIds: masteredIds ?? this.masteredIds,
    );
  }
}

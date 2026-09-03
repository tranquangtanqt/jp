class ExamLessonsState {
  final List<int> lessons;
  final Set<int> available;
  final Map<int, int> questionCounts;
  final bool isLoading;
  final String? error;

  const ExamLessonsState({
    this.lessons = const [],
    this.available = const {},
    this.questionCounts = const {},
    this.isLoading = false,
    this.error,
  });

  ExamLessonsState copyWith({
    List<int>? lessons,
    Set<int>? available,
    Map<int, int>? questionCounts,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ExamLessonsState(
      lessons: lessons ?? this.lessons,
      available: available ?? this.available,
      questionCounts: questionCounts ?? this.questionCounts,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

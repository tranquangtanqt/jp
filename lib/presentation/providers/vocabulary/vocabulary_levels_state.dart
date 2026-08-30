import '../../../domain/entities/learning_category_entity.dart';

class VocabularyLevelsState {
  final List<LearningCategoryEntity> levels;
  final Map<String, int> counts;
  final bool isLoading;
  final String? error;

  const VocabularyLevelsState({
    this.levels = const [],
    this.counts = const {},
    this.isLoading = false,
    this.error,
  });

  VocabularyLevelsState copyWith({
    List<LearningCategoryEntity>? levels,
    Map<String, int>? counts,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return VocabularyLevelsState(
      levels: levels ?? this.levels,
      counts: counts ?? this.counts,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

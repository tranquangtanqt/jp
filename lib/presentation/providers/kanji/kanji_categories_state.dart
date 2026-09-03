import '../../../domain/entities/learning_category_entity.dart';

class KanjiCategoriesState {
  final List<LearningCategoryEntity> categories;
  final Map<String, int> counts;
  final bool isLoading;
  final String? error;

  const KanjiCategoriesState({
    this.categories = const [],
    this.counts = const {},
    this.isLoading = false,
    this.error,
  });

  KanjiCategoriesState copyWith({
    List<LearningCategoryEntity>? categories,
    Map<String, int>? counts,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return KanjiCategoriesState(
      categories: categories ?? this.categories,
      counts: counts ?? this.counts,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

import '../../../domain/entities/vocabulary_entity.dart';
import '../../../domain/entities/vocabulary_unit_entity.dart';

class VocabularyDetailState {
  final List<VocabularyEntity> all;
  final List<VocabularyUnitEntity> units;
  final String keyword;
  final String unitFilter; // 'all' or unit id
  final int mistakeCount;
  final bool isLoading;
  final String? error;

  const VocabularyDetailState({
    this.all = const [],
    this.units = const [],
    this.keyword = '',
    this.unitFilter = 'all',
    this.mistakeCount = 0,
    this.isLoading = false,
    this.error,
  });

  List<VocabularyEntity> get filtered {
    final kw = keyword.trim().toLowerCase();

    return all.where((item) {
      final matchKeyword =
          kw.isEmpty ||
          item.hiragana.toLowerCase().contains(kw) ||
          item.kanji.toLowerCase().contains(kw) ||
          item.translate.toLowerCase().contains(kw);
      final matchUnit = unitFilter == 'all' || item.unit == unitFilter;

      return matchKeyword && matchUnit;
    }).toList();
  }

  VocabularyDetailState copyWith({
    List<VocabularyEntity>? all,
    List<VocabularyUnitEntity>? units,
    String? keyword,
    String? unitFilter,
    int? mistakeCount,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return VocabularyDetailState(
      all: all ?? this.all,
      units: units ?? this.units,
      keyword: keyword ?? this.keyword,
      unitFilter: unitFilter ?? this.unitFilter,
      mistakeCount: mistakeCount ?? this.mistakeCount,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

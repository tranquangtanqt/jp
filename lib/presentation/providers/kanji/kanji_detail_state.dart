import 'kanji_study_item.dart';

class KanjiDetailState {
  final List<KanjiStudyItem> all;
  final String keyword;
  final bool isRadicals;
  final int mistakeCount;
  final bool isLoading;
  final String? error;

  const KanjiDetailState({
    this.all = const [],
    this.keyword = '',
    this.isRadicals = false,
    this.mistakeCount = 0,
    this.isLoading = false,
    this.error,
  });

  List<KanjiStudyItem> get filtered => all.where((item) => item.matches(keyword)).toList();

  KanjiDetailState copyWith({
    List<KanjiStudyItem>? all,
    String? keyword,
    bool? isRadicals,
    int? mistakeCount,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return KanjiDetailState(
      all: all ?? this.all,
      keyword: keyword ?? this.keyword,
      isRadicals: isRadicals ?? this.isRadicals,
      mistakeCount: mistakeCount ?? this.mistakeCount,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

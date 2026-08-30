import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../../../domain/entities/learning_progress_entity.dart';
import '../../../domain/usecases/kanji_usecases.dart';
import '../../../domain/usecases/params/no_param.dart';
import '../../../domain/usecases/progress_usecases.dart';
import 'kanji_detail_state.dart';
import 'kanji_study_item.dart';

final kanjiDetailNotifierProvider = AutoDisposeNotifierProvider.family<KanjiDetailNotifier, KanjiDetailState, String>(
  KanjiDetailNotifier.new,
);

class KanjiDetailNotifier extends AutoDisposeFamilyNotifier<KanjiDetailState, String> {
  String get _categoryId => arg;

  @override
  KanjiDetailState build(String arg) => KanjiDetailState(isRadicals: arg == 'radicals');

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final kanjiRepo = ref.read(kanjiRepositoryProvider);
    final List<KanjiStudyItem> items;

    if (_categoryId == 'radicals') {
      final res = await GetRadicalsUsecase(kanjiRepo).call(const NoParam());

      if (res.isFailure) {
        state = state.copyWith(isLoading: false, error: res.message ?? 'Không tải được bộ thủ');

        return;
      }

      items = (res.data ?? []).map(KanjiStudyItem.fromRadical).toList();
    } else {
      final res = await GetKanjiByCategoryUsecase(kanjiRepo).call(_categoryId);

      if (res.isFailure) {
        state = state.copyWith(isLoading: false, error: res.message ?? 'Không tải được Kanji');

        return;
      }

      items = (res.data ?? []).map(KanjiStudyItem.fromKanji).toList();
    }

    final progress = await GetProgressUsecase(
      ref.read(progressRepositoryProvider),
    ).call((feature: ProgressFeature.kanji, scope: _categoryId));

    state = state.copyWith(
      all: items,
      mistakeCount: progress.data?.mistakeIds.length ?? 0,
      isLoading: false,
    );
  }

  void setKeyword(String value) => state = state.copyWith(keyword: value);
}

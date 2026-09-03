import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../../../domain/usecases/kanji_usecases.dart';
import '../../../domain/usecases/params/no_param.dart';
import 'kanji_categories_state.dart';

final kanjiCategoriesNotifierProvider = NotifierProvider<KanjiCategoriesNotifier, KanjiCategoriesState>(
  KanjiCategoriesNotifier.new,
);

class KanjiCategoriesNotifier extends Notifier<KanjiCategoriesState> {
  @override
  KanjiCategoriesState build() => const KanjiCategoriesState();

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final kanjiRepo = ref.read(kanjiRepositoryProvider);
    final categoriesRes = await GetKanjiCategoriesUsecase(kanjiRepo).call(const NoParam());

    if (categoriesRes.isFailure) {
      state = state.copyWith(isLoading: false, error: categoriesRes.message ?? 'Không tải được danh mục');

      return;
    }

    final categories = categoriesRes.data ?? [];
    final counts = <String, int>{};

    for (final category in categories.where((c) => !c.disabled)) {
      if (category.id == 'radicals') {
        final res = await GetRadicalsUsecase(kanjiRepo).call(const NoParam());
        counts[category.id] = res.data?.length ?? 0;
      } else {
        final res = await GetKanjiByCategoryUsecase(kanjiRepo).call(category.id);
        counts[category.id] = res.data?.length ?? 0;
      }
    }

    state = state.copyWith(categories: categories, counts: counts, isLoading: false);
  }
}

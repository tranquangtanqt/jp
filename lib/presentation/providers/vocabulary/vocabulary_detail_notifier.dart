import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../../../domain/entities/learning_progress_entity.dart';
import '../../../domain/usecases/progress_usecases.dart';
import '../../../domain/usecases/vocabulary_usecases.dart';
import 'vocabulary_detail_state.dart';

final vocabularyDetailNotifierProvider =
    AutoDisposeNotifierProvider.family<VocabularyDetailNotifier, VocabularyDetailState, String>(
      VocabularyDetailNotifier.new,
    );

class VocabularyDetailNotifier extends AutoDisposeFamilyNotifier<VocabularyDetailState, String> {
  String get _level => arg;

  @override
  VocabularyDetailState build(String arg) => const VocabularyDetailState();

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final vocabRepo = ref.read(vocabularyRepositoryProvider);
    final unitsRes = await GetVocabularyUnitsUsecase(vocabRepo).call(_level);
    final vocabRes = await GetVocabularyByLevelUsecase(vocabRepo).call(_level);

    if (vocabRes.isFailure) {
      state = state.copyWith(isLoading: false, error: vocabRes.message ?? 'Không tải được từ vựng');

      return;
    }

    final progressRes = await GetProgressUsecase(
      ref.read(progressRepositoryProvider),
    ).call((feature: ProgressFeature.vocabulary, scope: _level));

    state = state.copyWith(
      all: vocabRes.data ?? [],
      units: unitsRes.data ?? [],
      mistakeCount: progressRes.data?.mistakeIds.length ?? 0,
      isLoading: false,
    );
  }

  void setKeyword(String value) => state = state.copyWith(keyword: value);

  void setUnitFilter(String value) => state = state.copyWith(unitFilter: value);
}

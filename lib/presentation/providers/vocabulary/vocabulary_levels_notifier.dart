import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../../../domain/entities/learning_category_entity.dart';
import '../../../domain/usecases/vocabulary_usecases.dart';
import 'vocabulary_levels_state.dart';

final vocabularyLevelsNotifierProvider = NotifierProvider<VocabularyLevelsNotifier, VocabularyLevelsState>(
  VocabularyLevelsNotifier.new,
);

class VocabularyLevelsNotifier extends Notifier<VocabularyLevelsState> {
  static const _levels = <LearningCategoryEntity>[
    LearningCategoryEntity(
      id: 'N5',
      name: 'Từ vựng JLPT N5',
      description: 'Từ vựng theo 25 bài của giáo trình Minna no Nihongo Sơ cấp I.',
    ),
    LearningCategoryEntity(
      id: 'N4',
      name: 'Từ vựng JLPT N4',
      description: 'Từ vựng trong phạm vi kỳ thi JLPT N4.',
      disabled: true,
    ),
    LearningCategoryEntity(
      id: 'N3',
      name: 'Từ vựng JLPT N3',
      description: 'Từ vựng trong phạm vi kỳ thi JLPT N3.',
      disabled: true,
    ),
  ];

  @override
  VocabularyLevelsState build() => const VocabularyLevelsState(levels: _levels);

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final counts = <String, int>{};

    for (final level in _levels.where((l) => !l.disabled)) {
      final res = await GetVocabularyByLevelUsecase(ref.read(vocabularyRepositoryProvider)).call(level.id);
      counts[level.id] = res.data?.length ?? 0;
    }

    state = state.copyWith(counts: counts, isLoading: false);
  }
}

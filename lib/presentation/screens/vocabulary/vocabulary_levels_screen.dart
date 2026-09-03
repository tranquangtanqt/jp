import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/themes/app_sizes.dart';
import '../../providers/vocabulary/vocabulary_levels_notifier.dart';
import '../../widgets/learning_category_card.dart';

class VocabularyLevelsScreen extends ConsumerStatefulWidget {
  const VocabularyLevelsScreen({super.key});

  @override
  ConsumerState<VocabularyLevelsScreen> createState() => _VocabularyLevelsScreenState();
}

class _VocabularyLevelsScreenState extends ConsumerState<VocabularyLevelsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vocabularyLevelsNotifierProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vocabularyLevelsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Từ vựng')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.padding),
        itemCount: state.levels.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSizes.padding),
        itemBuilder: (context, index) {
          final level = state.levels[index];
          final count = state.counts[level.id];

          return LearningCategoryCard(
            title: level.name,
            subtitle: level.description,
            trailingInfo: level.disabled ? null : (count == null ? 'Đang tải...' : '$count từ vựng'),
            disabled: level.disabled,
            onTap: () => context.push('${AppRouteConst.vocabulary}/${level.id}'),
          );
        },
      ),
    );
  }
}

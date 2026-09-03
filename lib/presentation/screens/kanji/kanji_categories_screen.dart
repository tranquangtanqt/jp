import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/themes/app_sizes.dart';
import '../../providers/kanji/kanji_categories_notifier.dart';
import '../../widgets/learning_category_card.dart';

class KanjiCategoriesScreen extends ConsumerStatefulWidget {
  const KanjiCategoriesScreen({super.key});

  @override
  ConsumerState<KanjiCategoriesScreen> createState() => _KanjiCategoriesScreenState();
}

class _KanjiCategoriesScreenState extends ConsumerState<KanjiCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(kanjiCategoriesNotifierProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kanjiCategoriesNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kanji')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.padding),
        itemCount: state.categories.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSizes.padding),
        itemBuilder: (context, index) {
          final category = state.categories[index];
          final count = state.counts[category.id];
          final unit = category.id == 'radicals' ? 'bộ thủ' : 'Kanji';

          return LearningCategoryCard(
            title: category.name,
            subtitle: category.description,
            trailingInfo: category.disabled ? null : (count == null ? 'Đang tải...' : '$count $unit'),
            disabled: category.disabled,
            onTap: () => context.push('${AppRouteConst.kanji}/${category.id}'),
          );
        },
      ),
    );
  }
}

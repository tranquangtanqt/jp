import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/app_providers.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/themes/app_sizes.dart';
import '../../../domain/entities/vocabulary_entity.dart';
import '../../providers/vocabulary/vocabulary_detail_notifier.dart';
import 'components/vocabulary_item_sheet.dart';

class VocabularyDetailScreen extends ConsumerStatefulWidget {
  final String level;

  const VocabularyDetailScreen({super.key, required this.level});

  @override
  ConsumerState<VocabularyDetailScreen> createState() => _VocabularyDetailScreenState();
}

class _VocabularyDetailScreenState extends ConsumerState<VocabularyDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vocabularyDetailNotifierProvider(widget.level).notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(vocabularyDetailNotifierProvider(widget.level).notifier);
    final state = ref.watch(vocabularyDetailNotifierProvider(widget.level));
    final items = state.filtered;

    final canQuiz = state.all.length >= 2;

    return Scaffold(
      appBar: AppBar(title: Text('Từ vựng ${widget.level}')),
      floatingActionButton: canQuiz
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.quiz_outlined),
              label: const Text('Trắc nghiệm'),
              onPressed: () => context.push('${AppRouteConst.vocabulary}/${widget.level}/quiz'),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.padding, AppSizes.padding, AppSizes.padding, 8),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    isDense: true,
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Tìm hiragana, kanji, nghĩa...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: notifier.setKeyword,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: state.unitFilter,
                        isExpanded: true,
                        decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
                        items: [
                          const DropdownMenuItem(value: 'all', child: Text('Tất cả bài')),
                          for (final unit in state.units)
                            DropdownMenuItem(value: unit.unit, child: Text(unit.unitName)),
                        ],
                        onChanged: (value) => notifier.setUnitFilter(value ?? 'all'),
                      ),
                    ),
                    if (state.mistakeCount > 0) ...[
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.replay, size: 18),
                        label: Text('Ôn sai (${state.mistakeCount})'),
                        onPressed: () => context.push(
                          '${AppRouteConst.vocabulary}/${widget.level}/quiz?mode=mistakes',
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody(context, state.isLoading, state.error, items)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isLoading, String? error, List<VocabularyEntity> items) {
    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error));
    }

    if (items.isEmpty) {
      return const Center(child: Text('Không tìm thấy từ vựng phù hợp'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSizes.padding, 8, AppSizes.padding, 88),
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];

        return ListTile(
          title: Text(item.hiragana, style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text([if (item.kanji.isNotEmpty) item.kanji, item.translate].join(' · ')),
          trailing: IconButton(
            icon: const Icon(Icons.volume_up_outlined),
            onPressed: () => ref.read(ttsServiceProvider).speak(item.hiragana),
          ),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            builder: (_) => VocabularyItemSheet(item: item),
          ),
        );
      },
    );
  }
}

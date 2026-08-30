import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/themes/app_sizes.dart';
import '../../providers/kanji/kanji_detail_notifier.dart';
import '../../providers/kanji/kanji_study_item.dart';

class KanjiDetailScreen extends ConsumerStatefulWidget {
  final String categoryId;

  const KanjiDetailScreen({super.key, required this.categoryId});

  @override
  ConsumerState<KanjiDetailScreen> createState() => _KanjiDetailScreenState();
}

class _KanjiDetailScreenState extends ConsumerState<KanjiDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(kanjiDetailNotifierProvider(widget.categoryId).notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(kanjiDetailNotifierProvider(widget.categoryId).notifier);
    final state = ref.watch(kanjiDetailNotifierProvider(widget.categoryId));
    final items = state.filtered;
    final title = state.isRadicals ? 'Bộ thủ' : 'Kanji ${widget.categoryId.toUpperCase()}';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: state.all.length < 2
          ? null
          : FloatingActionButton.extended(
              icon: const Icon(Icons.quiz_outlined),
              label: const Text('Trắc nghiệm'),
              onPressed: () => context.push('${AppRouteConst.kanji}/${widget.categoryId}/quiz'),
            ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.padding, AppSizes.padding, AppSizes.padding, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      isDense: true,
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Tìm chữ, Hán Việt, nghĩa...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: notifier.setKeyword,
                  ),
                ),
                if (state.mistakeCount > 0) ...[
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.replay, size: 18),
                    label: Text('${state.mistakeCount}'),
                    onPressed: () => context.push('${AppRouteConst.kanji}/${widget.categoryId}/quiz?mode=mistakes'),
                  ),
                ],
              ],
            ),
          ),
          Expanded(child: _body(state.isLoading, state.error, items)),
        ],
      ),
    );
  }

  Widget _body(bool isLoading, String? error, List<KanjiStudyItem> items) {
    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error));
    }

    if (items.isEmpty) {
      return const Center(child: Text('Không tìm thấy kết quả'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSizes.padding, 8, AppSizes.padding, 88),
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];

        return ListTile(
          leading: Text(item.glyph, style: const TextStyle(fontSize: 30)),
          title: Text('${item.hanViet} · ${item.meaning}'),
          subtitle: item.onyomi != null
              ? Text('On: ${item.onyomi}   Kun: ${item.kunyomi}')
              : Text('Bộ ${item.number} · ${item.strokes} nét'),
          isThreeLine: item.example != null && item.example!.isNotEmpty,
          onTap: () => showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            builder: (_) => _KanjiSheet(item: item),
          ),
        );
      },
    );
  }
}

class _KanjiSheet extends StatelessWidget {
  final KanjiStudyItem item;

  const _KanjiSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.padding, 0, AppSizes.padding, AppSizes.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.glyph, style: theme.textTheme.displaySmall),
          const SizedBox(height: 8),
          Text('${item.hanViet} · ${item.meaning}', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          if (item.onyomi != null) Text('Âm On: ${item.onyomi}'),
          if (item.kunyomi != null) Text('Âm Kun: ${item.kunyomi}'),
          if (item.number != null) Text('Bộ thủ số ${item.number} · ${item.strokes} nét'),
          if (item.example != null && item.example!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Ví dụ: ${item.example}'),
          ],
        ],
      ),
    );
  }
}

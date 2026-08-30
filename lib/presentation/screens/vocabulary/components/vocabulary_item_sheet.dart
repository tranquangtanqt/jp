import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../core/themes/app_sizes.dart';
import '../../../../domain/entities/vocabulary_entity.dart';

class VocabularyItemSheet extends ConsumerWidget {
  final VocabularyEntity item;

  const VocabularyItemSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.padding, 0, AppSizes.padding, AppSizes.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(item.hiragana, style: theme.textTheme.headlineSmall)),
              IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () => ref.read(ttsServiceProvider).speak(item.hiragana),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _row(context, 'Kanji', item.kanji.isEmpty ? '-' : item.kanji),
          _row(context, 'Nghĩa', item.translate),
          _row(context, 'Bài', item.unitName),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

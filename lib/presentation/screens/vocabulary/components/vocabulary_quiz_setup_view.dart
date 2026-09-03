import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/app_sizes.dart';
import '../../../providers/vocabulary/vocabulary_quiz_notifier.dart';
import '../../../providers/vocabulary/vocabulary_quiz_state.dart';

class VocabularyQuizSetupView extends ConsumerWidget {
  final VocabularyQuizArg arg;

  const VocabularyQuizSetupView({super.key, required this.arg});

  static const _choiceCounts = [2, 3, 4, 5, 6, 8, 10];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(vocabularyQuizNotifierProvider(arg).notifier);
    final state = ref.watch(vocabularyQuizNotifierProvider(arg));

    return ListView(
      padding: const EdgeInsets.all(AppSizes.padding),
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: state.choiceCount,
                decoration: const InputDecoration(labelText: 'Số đáp án', border: OutlineInputBorder(), isDense: true),
                items: [for (final n in _choiceCounts) DropdownMenuItem(value: n, child: Text('$n'))],
                onChanged: (value) => notifier.setChoiceCount(value ?? 4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<QuizDirection>(
                initialValue: state.direction,
                decoration: const InputDecoration(labelText: 'Hình thức', border: OutlineInputBorder(), isDense: true),
                items: const [
                  DropdownMenuItem(value: QuizDirection.mixed, child: Text('Trộn lẫn')),
                  DropdownMenuItem(value: QuizDirection.viJa, child: Text('Việt → Nhật')),
                  DropdownMenuItem(value: QuizDirection.jaVi, child: Text('Nhật → Việt')),
                ],
                onChanged: (value) => notifier.setDirection(value ?? QuizDirection.mixed),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.padding),
        Text('Chọn các bài học muốn ôn tập:', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final unit in state.units)
              FilterChip(
                label: Text(unit.unitName),
                selected: state.selectedUnits.contains(unit.unit),
                onSelected: (_) => notifier.toggleUnit(unit.unit),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.padding),
        FilledButton(
          onPressed: state.selectedUnits.isEmpty ? null : notifier.start,
          child: const Text('Bắt đầu'),
        ),
      ],
    );
  }
}

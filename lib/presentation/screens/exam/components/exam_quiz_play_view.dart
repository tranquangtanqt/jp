import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/app_sizes.dart';
import '../../../providers/exam/exam_quiz_notifier.dart';

class ExamQuizPlayView extends ConsumerWidget {
  final ExamQuizArg arg;
  final Map<String, String> typeLabels;

  const ExamQuizPlayView({super.key, required this.arg, required this.typeLabels});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(examQuizNotifierProvider(arg).notifier);
    final state = ref.watch(examQuizNotifierProvider(arg));
    final question = state.currentQuestion;

    if (question == null) {
      return const Center(child: Text('Không có câu hỏi.'));
    }

    final theme = Theme.of(context);
    final source = question.source;

    return ListView(
      padding: const EdgeInsets.all(AppSizes.padding),
      children: [
        LinearProgressIndicator(value: (state.currentIndex + 1) / state.questions.length),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Câu ${state.currentIndex + 1}/${state.questions.length}  ·  Đúng ${state.correctCount}'
                '  ·  Sai ${state.wrongCount}  ·  ${typeLabels[source.type] ?? source.type}',
                style: theme.textTheme.bodySmall,
              ),
            ),
            Text('Đã làm ${state.scopeMastered}/${state.pool.length}', style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 12),
        if (source.passage != null && source.passage!.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(source.passage!, style: theme.textTheme.bodyMedium),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(source.question, style: theme.textTheme.titleMedium),
        ),
        ...List.generate(question.options.length, (index) {
          final isCorrect = index == question.answerIndex;
          final isSelected = index == state.selectedIndex;

          Color? color;
          if (state.isAnswered && isCorrect) {
            color = Colors.green.shade600;
          } else if (state.isAnswered && isSelected) {
            color = Colors.red.shade600;
          }

          return Card(
            color: color,
            child: ListTile(
              title: Text(
                question.options[index],
                style: TextStyle(color: color != null ? Colors.white : null),
              ),
              onTap: state.isAnswered ? null : () => notifier.submit(index),
            ),
          );
        }),
        if (state.isAnswered) ...[
          const SizedBox(height: 8),
          Card(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Giải thích', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(source.explanation.isEmpty ? 'Không có giải thích.' : source.explanation),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: notifier.next,
            child: Text(state.currentIndex + 1 >= state.questions.length ? 'Xem kết quả' : 'Câu tiếp theo'),
          ),
        ],
      ],
    );
  }
}

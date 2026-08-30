import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/app_providers.dart';
import '../../../../core/themes/app_sizes.dart';
import '../../../../domain/entities/vocabulary_entity.dart';
import '../../../providers/vocabulary/vocabulary_quiz_notifier.dart';
import '../../../providers/vocabulary/vocabulary_quiz_state.dart';

class VocabularyQuizPlayView extends ConsumerWidget {
  final VocabularyQuizArg arg;

  const VocabularyQuizPlayView({super.key, required this.arg});

  static String _renderJapanese(VocabularyEntity item) =>
      item.kanji.isNotEmpty ? '${item.hiragana} (${item.kanji})' : item.hiragana;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(vocabularyQuizNotifierProvider(arg).notifier);
    final state = ref.watch(vocabularyQuizNotifierProvider(arg));
    final question = state.currentQuestion;

    if (question == null) {
      return const Center(child: Text('Không có câu hỏi.'));
    }

    final theme = Theme.of(context);
    final isJaVi = question.direction == QuestionDirection.jaVi;
    final questionText = isJaVi ? _renderJapanese(question.target) : question.target.translate;

    return ListView(
      padding: const EdgeInsets.all(AppSizes.padding),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Câu ${state.currentIndex + 1}/${state.questions.length}  ·  Đúng ${state.correctCount}  ·  Sai ${state.wrongCount}',
              style: theme.textTheme.bodySmall,
            ),
            Text('Đã thuộc ${state.scopeMastered}/${state.pool.length}', style: theme.textTheme.bodySmall),
          ],
        ),
        if (!state.mistakeMode && state.scopeMastered > 0)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Xoá tiến độ'),
              onPressed: () => _confirmClear(context, notifier),
            ),
          ),
        const SizedBox(height: 8),
        Card(
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    questionText,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                if (isJaVi)
                  IconButton(
                    icon: const Icon(Icons.volume_up_outlined),
                    onPressed: () => ref.read(ttsServiceProvider).speak(question.target.hiragana),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.padding),
        if (!state.showChoices)
          FilledButton.tonal(onPressed: notifier.reveal, child: const Text('Hiển thị đáp án'))
        else
          ...question.choices.map((choice) => _choiceTile(context, ref, state, question, choice, isJaVi)),
        if (state.isAnswered) ...[
          const SizedBox(height: AppSizes.padding),
          Card(
            color: state.isCorrect ? Colors.green.shade600 : Colors.red.shade600,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${state.isCorrect ? 'Chính xác!' : 'Chưa đúng.'} Đáp án: '
                '${_renderJapanese(question.target)} - ${question.target.translate}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: notifier.next, child: const Text('Câu hỏi tiếp theo')),
        ],
      ],
    );
  }

  Widget _choiceTile(
    BuildContext context,
    WidgetRef ref,
    VocabularyQuizState state,
    VocabularyQuizQuestion question,
    VocabularyEntity choice,
    bool isJaVi,
  ) {
    final isTarget = choice.id == question.target.id;
    final isSelected = choice.id == state.selectedChoiceId;

    Color? tileColor;
    if (state.isAnswered && isTarget) {
      tileColor = Colors.green.shade600;
    } else if (state.isAnswered && isSelected) {
      tileColor = Colors.red.shade600;
    }

    final answered = state.isAnswered;
    final text = isJaVi ? choice.translate : _renderJapanese(choice);

    return Card(
      color: tileColor,
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(color: tileColor != null ? Colors.white : null),
        ),
        trailing: isJaVi
            ? null
            : IconButton(
                icon: Icon(Icons.volume_up_outlined, color: tileColor != null ? Colors.white : null),
                onPressed: () => ref.read(ttsServiceProvider).speak(choice.hiragana),
              ),
        onTap: answered ? null : () => ref.read(vocabularyQuizNotifierProvider(arg).notifier).submit(choice),
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, VocabularyQuizNotifier notifier) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xoá tiến độ'),
        content: const Text('Xoá toàn bộ tiến độ đã lưu của mục này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xoá')),
        ],
      ),
    );

    if (ok == true) {
      await notifier.clearProgress();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_sizes.dart';
import '../../providers/kanji/kanji_quiz_notifier.dart';
import '../../providers/kanji/kanji_quiz_state.dart';
import '../../providers/kanji/kanji_study_item.dart';

class KanjiQuizScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final bool mistakeMode;

  const KanjiQuizScreen({super.key, required this.categoryId, this.mistakeMode = false});

  @override
  ConsumerState<KanjiQuizScreen> createState() => _KanjiQuizScreenState();
}

class _KanjiQuizScreenState extends ConsumerState<KanjiQuizScreen> {
  late final KanjiQuizArg _arg = (categoryId: widget.categoryId, mistakeMode: widget.mistakeMode);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(kanjiQuizNotifierProvider(_arg).notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kanjiQuizNotifierProvider(_arg));
    final title = widget.categoryId == 'radicals' ? 'Bộ thủ' : widget.categoryId.toUpperCase();

    return Scaffold(
      appBar: AppBar(title: Text('Trắc nghiệm Kanji - $title')),
      body: _body(state),
    );
  }

  Widget _body(KanjiQuizState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Center(child: Text(state.error!, textAlign: TextAlign.center)),
      );
    }

    return switch (state.phase) {
      KanjiQuizPhase.setup => _SetupView(arg: _arg),
      KanjiQuizPhase.playing => _PlayView(arg: _arg),
    };
  }
}

class _SetupView extends ConsumerWidget {
  final KanjiQuizArg arg;

  const _SetupView({required this.arg});

  static const _choiceCounts = [2, 3, 4, 5, 6, 8];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(kanjiQuizNotifierProvider(arg).notifier);
    final state = ref.watch(kanjiQuizNotifierProvider(arg));

    return ListView(
      padding: const EdgeInsets.all(AppSizes.padding),
      children: [
        DropdownButtonFormField<int>(
          initialValue: state.choiceCount,
          decoration: const InputDecoration(labelText: 'Số đáp án', border: OutlineInputBorder(), isDense: true),
          items: [for (final n in _choiceCounts) DropdownMenuItem(value: n, child: Text('$n'))],
          onChanged: (value) => notifier.setChoiceCount(value ?? 4),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<KanjiQuizDirection>(
          initialValue: state.direction,
          decoration: const InputDecoration(labelText: 'Hình thức', border: OutlineInputBorder(), isDense: true),
          items: const [
            DropdownMenuItem(value: KanjiQuizDirection.mixed, child: Text('Trộn lẫn')),
            DropdownMenuItem(value: KanjiQuizDirection.glyphToMeaning, child: Text('Chữ → Nghĩa')),
            DropdownMenuItem(value: KanjiQuizDirection.meaningToGlyph, child: Text('Nghĩa → Chữ')),
          ],
          onChanged: (value) => notifier.setDirection(value ?? KanjiQuizDirection.mixed),
        ),
        const SizedBox(height: AppSizes.padding),
        FilledButton(onPressed: notifier.start, child: const Text('Bắt đầu')),
      ],
    );
  }
}

class _PlayView extends ConsumerWidget {
  final KanjiQuizArg arg;

  const _PlayView({required this.arg});

  String _label(KanjiStudyItem item) => '${item.hanViet} · ${item.meaning}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(kanjiQuizNotifierProvider(arg).notifier);
    final state = ref.watch(kanjiQuizNotifierProvider(arg));
    final question = state.currentQuestion;

    if (question == null) {
      return const Center(child: Text('Không có câu hỏi.'));
    }

    final theme = Theme.of(context);
    final showGlyph = question.direction == KanjiQuestionDirection.glyphToMeaning;

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
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                showGlyph ? question.target.glyph : _label(question.target),
                textAlign: TextAlign.center,
                style: showGlyph ? const TextStyle(fontSize: 56) : theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.padding),
        ...question.choices.map((choice) {
          final isTarget = choice.id == question.target.id;
          final isSelected = choice.id == state.selectedChoiceId;

          Color? color;
          if (state.isAnswered && isTarget) {
            color = Colors.green.shade600;
          } else if (state.isAnswered && isSelected) {
            color = Colors.red.shade600;
          }

          return Card(
            color: color,
            child: ListTile(
              title: Text(
                showGlyph ? _label(choice) : choice.glyph,
                style: TextStyle(
                  color: color != null ? Colors.white : null,
                  fontSize: showGlyph ? null : 28,
                ),
              ),
              onTap: state.isAnswered ? null : () => notifier.submit(choice),
            ),
          );
        }),
        if (state.isAnswered) ...[
          const SizedBox(height: AppSizes.padding),
          Card(
            color: state.isCorrect ? Colors.green.shade600 : Colors.red.shade600,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${state.isCorrect ? 'Chính xác!' : 'Chưa đúng.'} Đáp án: '
                '${question.target.glyph} - ${_label(question.target)}',
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

  Future<void> _confirmClear(BuildContext context, KanjiQuizNotifier notifier) async {
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

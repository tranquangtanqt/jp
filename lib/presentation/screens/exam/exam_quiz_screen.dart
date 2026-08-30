import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_sizes.dart';
import '../../providers/exam/exam_quiz_notifier.dart';
import '../../providers/exam/exam_quiz_state.dart';
import 'components/exam_quiz_play_view.dart';

const _typeLabels = <String, String>{
  'vocabulary': 'Từ vựng',
  'grammar': 'Ngữ pháp',
  'kanji': 'Kanji',
  'reading': 'Đọc hiểu',
  'dialogue': 'Hội thoại',
};

class ExamQuizScreen extends ConsumerStatefulWidget {
  final int lesson;
  final bool mistakeMode;

  const ExamQuizScreen({super.key, required this.lesson, this.mistakeMode = false});

  @override
  ConsumerState<ExamQuizScreen> createState() => _ExamQuizScreenState();
}

class _ExamQuizScreenState extends ConsumerState<ExamQuizScreen> {
  late final ExamQuizArg _arg = (lesson: widget.lesson, mistakeMode: widget.mistakeMode);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(examQuizNotifierProvider(_arg).notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(examQuizNotifierProvider(_arg));

    return Scaffold(
      appBar: AppBar(title: Text('Đề thi - Bài ${widget.lesson}')),
      body: _body(state),
    );
  }

  Widget _body(ExamQuizState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.phase == ExamQuizPhase.setup) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Center(child: Text(state.error!, textAlign: TextAlign.center)),
      );
    }

    return switch (state.phase) {
      ExamQuizPhase.setup => _SetupView(arg: _arg),
      ExamQuizPhase.playing => ExamQuizPlayView(arg: _arg, typeLabels: _typeLabels),
      ExamQuizPhase.finished => _FinishedView(arg: _arg),
    };
  }
}

class _SetupView extends ConsumerWidget {
  final ExamQuizArg arg;

  const _SetupView({required this.arg});

  static const _counts = [10, 20, 30];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(examQuizNotifierProvider(arg).notifier);
    final state = ref.watch(examQuizNotifierProvider(arg));

    return ListView(
      padding: const EdgeInsets.all(AppSizes.padding),
      children: [
        DropdownButtonFormField<int>(
          initialValue: state.questionCount,
          decoration: const InputDecoration(labelText: 'Số câu hỏi', border: OutlineInputBorder(), isDense: true),
          items: [for (final n in _counts) DropdownMenuItem(value: n, child: Text('$n câu'))],
          onChanged: (value) => notifier.setCount(value ?? 10),
        ),
        const SizedBox(height: AppSizes.padding),
        Text('Lọc theo dạng câu (bỏ trống = tất cả):', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final type in state.availableTypes)
              FilterChip(
                label: Text(_typeLabels[type] ?? type),
                selected: state.typeFilter.contains(type),
                onSelected: (_) => notifier.toggleType(type),
              ),
          ],
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text('Chỉ làm câu chưa làm'),
          value: state.onlyNotDone,
          onChanged: (_) => notifier.toggleOnlyNotDone(),
        ),
        const SizedBox(height: AppSizes.padding),
        FilledButton(onPressed: notifier.start, child: const Text('Làm bài')),
      ],
    );
  }
}

class _FinishedView extends ConsumerWidget {
  final ExamQuizArg arg;

  const _FinishedView({required this.arg});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(examQuizNotifierProvider(arg).notifier);
    final state = ref.watch(examQuizNotifierProvider(arg));
    final total = state.questions.length;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hoàn thành!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Đúng ${state.correctCount}/$total câu', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('Kết quả tốt nhất: ${state.bestCorrect}/${state.bestTotal}'),
            const SizedBox(height: AppSizes.padding),
            FilledButton(onPressed: notifier.restart, child: const Text('Làm lại')),
          ],
        ),
      ),
    );
  }
}

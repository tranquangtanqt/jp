import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_sizes.dart';
import '../../providers/vocabulary/vocabulary_quiz_notifier.dart';
import '../../providers/vocabulary/vocabulary_quiz_state.dart';
import 'components/vocabulary_quiz_play_view.dart';
import 'components/vocabulary_quiz_setup_view.dart';

class VocabularyQuizScreen extends ConsumerStatefulWidget {
  final String level;
  final bool mistakeMode;

  const VocabularyQuizScreen({super.key, required this.level, this.mistakeMode = false});

  @override
  ConsumerState<VocabularyQuizScreen> createState() => _VocabularyQuizScreenState();
}

class _VocabularyQuizScreenState extends ConsumerState<VocabularyQuizScreen> {
  late final VocabularyQuizArg _arg = (level: widget.level, mistakeMode: widget.mistakeMode);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vocabularyQuizNotifierProvider(_arg).notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vocabularyQuizNotifierProvider(_arg));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mistakeMode ? 'Ôn lại câu sai - ${widget.level}' : 'Trắc nghiệm ${widget.level}'),
      ),
      body: _body(state),
    );
  }

  Widget _body(VocabularyQuizState state) {
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
      QuizPhase.setup => VocabularyQuizSetupView(arg: _arg),
      QuizPhase.playing => VocabularyQuizPlayView(arg: _arg),
    };
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/themes/app_sizes.dart';
import '../../providers/exam/exam_lessons_notifier.dart';

class ExamLessonsScreen extends ConsumerStatefulWidget {
  const ExamLessonsScreen({super.key});

  @override
  ConsumerState<ExamLessonsScreen> createState() => _ExamLessonsScreenState();
}

class _ExamLessonsScreenState extends ConsumerState<ExamLessonsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(examLessonsNotifierProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(examLessonsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Đề thi thử JLPT N5')),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSizes.padding),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
        ),
        itemCount: state.lessons.length,
        itemBuilder: (context, index) {
          final lesson = state.lessons[index];
          final available = state.available.contains(lesson);
          final count = state.questionCounts[lesson];

          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSizes.radius),
              onTap: available ? () => context.push('${AppRouteConst.exam}/$lesson/quiz') : null,
              child: Opacity(
                opacity: available ? 1 : 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Bài $lesson', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        state.isLoading
                            ? '...'
                            : available
                            ? '${count ?? 0} câu hỏi'
                            : 'Chưa có đề',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

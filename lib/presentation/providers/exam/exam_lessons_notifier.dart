import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/app_providers.dart';
import '../../../domain/usecases/exam_usecases.dart';
import '../../../domain/usecases/params/no_param.dart';
import 'exam_lessons_state.dart';

final examLessonsNotifierProvider = NotifierProvider<ExamLessonsNotifier, ExamLessonsState>(
  ExamLessonsNotifier.new,
);

class ExamLessonsNotifier extends Notifier<ExamLessonsState> {
  static const _totalLessons = 25;

  @override
  ExamLessonsState build() => ExamLessonsState(lessons: List.generate(_totalLessons, (i) => i + 1));

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final examRepo = ref.read(examRepositoryProvider);
    final res = await GetAvailableLessonsUsecase(examRepo).call(const NoParam());

    if (res.isFailure) {
      state = state.copyWith(isLoading: false, error: res.message ?? 'Không tải được danh sách đề');

      return;
    }

    final available = (res.data ?? []).toSet();
    final counts = <int, int>{};

    for (final lesson in available) {
      final lessonRes = await GetExamLessonUsecase(examRepo).call(lesson);
      counts[lesson] = lessonRes.data?.questions.length ?? 0;
    }

    state = state.copyWith(available: available, questionCounts: counts, isLoading: false);
  }
}

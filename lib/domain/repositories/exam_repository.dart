import '../../core/common/result.dart';
import '../entities/exam_lesson_entity.dart';

abstract class ExamRepository {
  Future<Result<List<int>>> getAvailableLessons();

  Future<Result<ExamLessonEntity>> getLesson(int lesson);
}

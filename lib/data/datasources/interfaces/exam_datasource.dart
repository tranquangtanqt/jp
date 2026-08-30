import '../../../domain/entities/exam_lesson_entity.dart';

abstract class ExamDatasource {
  /// Lesson numbers (1..25) that have a bundled question file.
  Future<List<int>> getAvailableLessons();

  Future<ExamLessonEntity?> getLesson(int lesson);
}

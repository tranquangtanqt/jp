import '../../core/common/result.dart';
import '../../domain/entities/exam_lesson_entity.dart';
import '../../domain/repositories/exam_repository.dart';
import '../datasources/interfaces/exam_datasource.dart';

class ExamRepositoryImpl implements ExamRepository {
  ExamRepositoryImpl(this._datasource);

  final ExamDatasource _datasource;

  @override
  Future<Result<List<int>>> getAvailableLessons() async {
    try {
      return Result.success(data: await _datasource.getAvailableLessons());
    } catch (e, s) {
      return Result.failure(title: 'Đề thi', message: 'Không tải được danh sách đề', error: e, stackTrace: s);
    }
  }

  @override
  Future<Result<ExamLessonEntity>> getLesson(int lesson) async {
    try {
      final data = await _datasource.getLesson(lesson);

      if (data == null) {
        return Result.failure(
          title: 'Đề thi',
          message: 'Chưa có đề cho bài $lesson',
          error: 'lesson $lesson not found',
        );
      }

      return Result.success(data: data);
    } catch (e, s) {
      return Result.failure(title: 'Đề thi', message: 'Không tải được đề', error: e, stackTrace: s);
    }
  }
}

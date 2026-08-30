import '../../core/common/result.dart';
import '../../core/usecase/usecase.dart';
import '../entities/exam_lesson_entity.dart';
import '../repositories/exam_repository.dart';
import 'params/no_param.dart';

class GetAvailableLessonsUsecase extends Usecase<Result<List<int>>, NoParam> {
  GetAvailableLessonsUsecase(this._repository);

  final ExamRepository _repository;

  @override
  Future<Result<List<int>>> call(NoParam params) => _repository.getAvailableLessons();
}

class GetExamLessonUsecase extends Usecase<Result<ExamLessonEntity>, int> {
  GetExamLessonUsecase(this._repository);

  final ExamRepository _repository;

  @override
  Future<Result<ExamLessonEntity>> call(int lesson) => _repository.getLesson(lesson);
}

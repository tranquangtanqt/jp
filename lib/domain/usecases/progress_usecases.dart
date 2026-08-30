import '../../core/common/result.dart';
import '../../core/usecase/usecase.dart';
import '../entities/learning_progress_entity.dart';
import '../repositories/progress_repository.dart';

typedef ScopeParams = ({ProgressFeature feature, String scope});
typedef AnswerParams = ({ProgressFeature feature, String scope, String itemId, bool correct});
typedef MasteredParams = ({ProgressFeature feature, String scope, String itemId});
typedef ExamProgressParams = ({int lesson, int correct, int total});

class GetProgressUsecase extends Usecase<Result<LearningProgressEntity>, ScopeParams> {
  GetProgressUsecase(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Result<LearningProgressEntity>> call(ScopeParams params) =>
      _repository.getProgress(params.feature, params.scope);
}

class RecordMasteredUsecase extends Usecase<Result<void>, MasteredParams> {
  RecordMasteredUsecase(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Result<void>> call(MasteredParams params) =>
      _repository.recordMastered(params.feature, params.scope, params.itemId);
}

class RecordAnswerUsecase extends Usecase<Result<void>, AnswerParams> {
  RecordAnswerUsecase(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Result<void>> call(AnswerParams params) =>
      _repository.recordAnswer(params.feature, params.scope, params.itemId, params.correct);
}

class ClearMasteredUsecase extends Usecase<Result<void>, ScopeParams> {
  ClearMasteredUsecase(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Result<void>> call(ScopeParams params) => _repository.clearMastered(params.feature, params.scope);
}

class GetExamProgressUsecase extends Usecase<Result<ExamProgressEntity>, int> {
  GetExamProgressUsecase(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Result<ExamProgressEntity>> call(int lesson) => _repository.getExamProgress(lesson);
}

class SaveExamProgressUsecase extends Usecase<Result<void>, ExamProgressParams> {
  SaveExamProgressUsecase(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Result<void>> call(ExamProgressParams params) =>
      _repository.saveExamProgress(params.lesson, params.correct, params.total);
}

class ClearExamProgressUsecase extends Usecase<Result<void>, int> {
  ClearExamProgressUsecase(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Result<void>> call(int lesson) => _repository.clearExamProgress(lesson);
}

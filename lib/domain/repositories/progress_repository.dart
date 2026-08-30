import '../../core/common/result.dart';
import '../entities/learning_progress_entity.dart';

abstract class ProgressRepository {
  Future<Result<LearningProgressEntity>> getProgress(ProgressFeature feature, String scope);

  Future<Result<void>> recordMastered(ProgressFeature feature, String scope, String itemId);

  Future<Result<void>> recordAnswer(ProgressFeature feature, String scope, String itemId, bool correct);

  Future<Result<void>> clearMastered(ProgressFeature feature, String scope);

  Future<Result<ExamProgressEntity>> getExamProgress(int lesson);

  Future<Result<void>> saveExamProgress(int lesson, int correct, int total);

  Future<Result<void>> clearExamProgress(int lesson);
}

import '../../../domain/entities/learning_progress_entity.dart';

abstract class ProgressDatasource {
  Future<LearningProgressEntity> getProgress(ProgressFeature feature, String scope);

  Future<void> recordMastered(ProgressFeature feature, String scope, String itemId);

  Future<void> recordAnswer(ProgressFeature feature, String scope, String itemId, bool correct);

  Future<void> clearMastered(ProgressFeature feature, String scope);

  Future<ExamProgressEntity> getExamProgress(int lesson);

  Future<void> saveExamProgress(int lesson, int correct, int total);

  Future<void> clearExamProgress(int lesson);
}

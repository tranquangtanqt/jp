import '../../core/common/result.dart';
import '../../domain/entities/learning_progress_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/interfaces/progress_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl(this._datasource);

  final ProgressDatasource _datasource;

  Future<Result<T>> _guard<T>(Future<T> Function() action, String message) async {
    try {
      return Result.success(data: await action());
    } catch (e, s) {
      return Result.failure(title: 'Tiến độ', message: message, error: e, stackTrace: s);
    }
  }

  Future<Result<void>> _guardVoid(Future<void> Function() action, String message) async {
    try {
      await action();

      return Result.success(data: null);
    } catch (e, s) {
      return Result.failure(title: 'Tiến độ', message: message, error: e, stackTrace: s);
    }
  }

  @override
  Future<Result<LearningProgressEntity>> getProgress(ProgressFeature feature, String scope) =>
      _guard(() => _datasource.getProgress(feature, scope), 'Không đọc được tiến độ');

  @override
  Future<Result<void>> recordMastered(ProgressFeature feature, String scope, String itemId) =>
      _guardVoid(() => _datasource.recordMastered(feature, scope, itemId), 'Không lưu được tiến độ');

  @override
  Future<Result<void>> recordAnswer(ProgressFeature feature, String scope, String itemId, bool correct) =>
      _guardVoid(() => _datasource.recordAnswer(feature, scope, itemId, correct), 'Không lưu được kết quả');

  @override
  Future<Result<void>> clearMastered(ProgressFeature feature, String scope) =>
      _guardVoid(() => _datasource.clearMastered(feature, scope), 'Không xoá được tiến độ');

  @override
  Future<Result<ExamProgressEntity>> getExamProgress(int lesson) =>
      _guard(() => _datasource.getExamProgress(lesson), 'Không đọc được tiến độ');

  @override
  Future<Result<void>> saveExamProgress(int lesson, int correct, int total) =>
      _guardVoid(() => _datasource.saveExamProgress(lesson, correct, total), 'Không lưu được tiến độ');

  @override
  Future<Result<void>> clearExamProgress(int lesson) =>
      _guardVoid(() => _datasource.clearExamProgress(lesson), 'Không xoá được tiến độ');
}

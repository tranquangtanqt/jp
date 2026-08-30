import '../../core/common/result.dart';
import '../../domain/entities/vocabulary_entity.dart';
import '../../domain/entities/vocabulary_unit_entity.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../datasources/interfaces/vocabulary_datasource.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  VocabularyRepositoryImpl(this._datasource);

  final VocabularyDatasource _datasource;

  @override
  Future<Result<List<VocabularyUnitEntity>>> getUnits(String level) async {
    try {
      return Result.success(data: await _datasource.getUnits(level));
    } catch (e, s) {
      return Result.failure(title: 'Từ vựng', message: 'Không tải được danh sách bài', error: e, stackTrace: s);
    }
  }

  @override
  Future<Result<List<VocabularyEntity>>> getVocabularyByLevel(String level) async {
    try {
      return Result.success(data: await _datasource.getVocabularyByLevel(level));
    } catch (e, s) {
      return Result.failure(title: 'Từ vựng', message: 'Không tải được từ vựng', error: e, stackTrace: s);
    }
  }
}

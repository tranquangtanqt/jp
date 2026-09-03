import '../../core/common/result.dart';
import '../../domain/entities/kanji_entity.dart';
import '../../domain/entities/learning_category_entity.dart';
import '../../domain/entities/radical_entity.dart';
import '../../domain/repositories/kanji_repository.dart';
import '../datasources/interfaces/kanji_datasource.dart';

class KanjiRepositoryImpl implements KanjiRepository {
  KanjiRepositoryImpl(this._datasource);

  final KanjiDatasource _datasource;

  @override
  Future<Result<List<LearningCategoryEntity>>> getCategories() async {
    try {
      return Result.success(data: await _datasource.getCategories());
    } catch (e, s) {
      return Result.failure(title: 'Kanji', message: 'Không tải được danh mục', error: e, stackTrace: s);
    }
  }

  @override
  Future<Result<List<KanjiEntity>>> getKanjiByCategory(String categoryId) async {
    try {
      return Result.success(data: await _datasource.getKanjiByCategory(categoryId));
    } catch (e, s) {
      return Result.failure(title: 'Kanji', message: 'Không tải được Kanji', error: e, stackTrace: s);
    }
  }

  @override
  Future<Result<List<RadicalEntity>>> getRadicals() async {
    try {
      return Result.success(data: await _datasource.getRadicals());
    } catch (e, s) {
      return Result.failure(title: 'Kanji', message: 'Không tải được bộ thủ', error: e, stackTrace: s);
    }
  }
}

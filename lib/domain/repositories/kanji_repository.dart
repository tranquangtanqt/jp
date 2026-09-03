import '../../core/common/result.dart';
import '../entities/kanji_entity.dart';
import '../entities/learning_category_entity.dart';
import '../entities/radical_entity.dart';

abstract class KanjiRepository {
  Future<Result<List<LearningCategoryEntity>>> getCategories();

  Future<Result<List<KanjiEntity>>> getKanjiByCategory(String categoryId);

  Future<Result<List<RadicalEntity>>> getRadicals();
}

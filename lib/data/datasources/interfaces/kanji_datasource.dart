import '../../../domain/entities/kanji_entity.dart';
import '../../../domain/entities/learning_category_entity.dart';
import '../../../domain/entities/radical_entity.dart';

abstract class KanjiDatasource {
  Future<List<LearningCategoryEntity>> getCategories();

  Future<List<KanjiEntity>> getKanjiByCategory(String categoryId);

  Future<List<RadicalEntity>> getRadicals();
}

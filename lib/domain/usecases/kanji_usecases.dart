import '../../core/common/result.dart';
import '../../core/usecase/usecase.dart';
import '../entities/kanji_entity.dart';
import '../entities/learning_category_entity.dart';
import '../entities/radical_entity.dart';
import '../repositories/kanji_repository.dart';
import 'params/no_param.dart';

class GetKanjiCategoriesUsecase extends Usecase<Result<List<LearningCategoryEntity>>, NoParam> {
  GetKanjiCategoriesUsecase(this._repository);

  final KanjiRepository _repository;

  @override
  Future<Result<List<LearningCategoryEntity>>> call(NoParam params) => _repository.getCategories();
}

class GetKanjiByCategoryUsecase extends Usecase<Result<List<KanjiEntity>>, String> {
  GetKanjiByCategoryUsecase(this._repository);

  final KanjiRepository _repository;

  @override
  Future<Result<List<KanjiEntity>>> call(String categoryId) => _repository.getKanjiByCategory(categoryId);
}

class GetRadicalsUsecase extends Usecase<Result<List<RadicalEntity>>, NoParam> {
  GetRadicalsUsecase(this._repository);

  final KanjiRepository _repository;

  @override
  Future<Result<List<RadicalEntity>>> call(NoParam params) => _repository.getRadicals();
}

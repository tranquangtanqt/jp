import '../../core/common/result.dart';
import '../../core/usecase/usecase.dart';
import '../entities/vocabulary_entity.dart';
import '../entities/vocabulary_unit_entity.dart';
import '../repositories/vocabulary_repository.dart';

class GetVocabularyUnitsUsecase extends Usecase<Result<List<VocabularyUnitEntity>>, String> {
  GetVocabularyUnitsUsecase(this._repository);

  final VocabularyRepository _repository;

  @override
  Future<Result<List<VocabularyUnitEntity>>> call(String level) => _repository.getUnits(level);
}

class GetVocabularyByLevelUsecase extends Usecase<Result<List<VocabularyEntity>>, String> {
  GetVocabularyByLevelUsecase(this._repository);

  final VocabularyRepository _repository;

  @override
  Future<Result<List<VocabularyEntity>>> call(String level) => _repository.getVocabularyByLevel(level);
}

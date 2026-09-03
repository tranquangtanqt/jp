import '../../core/common/result.dart';
import '../entities/vocabulary_entity.dart';
import '../entities/vocabulary_unit_entity.dart';

abstract class VocabularyRepository {
  Future<Result<List<VocabularyUnitEntity>>> getUnits(String level);

  Future<Result<List<VocabularyEntity>>> getVocabularyByLevel(String level);
}

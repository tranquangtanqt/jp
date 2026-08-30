import '../../../domain/entities/vocabulary_entity.dart';
import '../../../domain/entities/vocabulary_unit_entity.dart';

abstract class VocabularyDatasource {
  Future<List<VocabularyUnitEntity>> getUnits(String level);

  Future<List<VocabularyEntity>> getVocabularyByLevel(String level);
}

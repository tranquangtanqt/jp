import 'package:flutter_test/flutter_test.dart';
import 'package:nihongo_n5/core/services/database/database_service.dart';
import 'package:nihongo_n5/data/datasources/local/progress_local_datasource_impl.dart';
import 'package:nihongo_n5/domain/entities/learning_progress_entity.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late ProgressLocalDatasourceImpl datasource;

  setUp(() async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await DatabaseService.instance.initTestDatabase(testDatabase: db);
    datasource = ProgressLocalDatasourceImpl(DatabaseService.instance);
  });

  test('records mistakes and clears them when answered correctly', () async {
    await datasource.recordAnswer(ProgressFeature.vocabulary, 'N5', 'unit_1-0', false);
    await datasource.recordAnswer(ProgressFeature.vocabulary, 'N5', 'unit_1-1', false);

    var progress = await datasource.getProgress(ProgressFeature.vocabulary, 'N5');
    expect(progress.mistakeIds, {'unit_1-0', 'unit_1-1'});

    await datasource.recordAnswer(ProgressFeature.vocabulary, 'N5', 'unit_1-0', true);

    progress = await datasource.getProgress(ProgressFeature.vocabulary, 'N5');
    expect(progress.mistakeIds, {'unit_1-1'});
  });

  test('records and clears mastered items', () async {
    await datasource.recordMastered(ProgressFeature.kanji, 'n5', 'k1');
    await datasource.recordMastered(ProgressFeature.kanji, 'n5', 'k1');
    await datasource.recordMastered(ProgressFeature.kanji, 'n5', 'k2');

    var progress = await datasource.getProgress(ProgressFeature.kanji, 'n5');
    expect(progress.masteredIds, {'k1', 'k2'});

    await datasource.clearMastered(ProgressFeature.kanji, 'n5');

    progress = await datasource.getProgress(ProgressFeature.kanji, 'n5');
    expect(progress.masteredIds, isEmpty);
  });

  test('stores exam progress per lesson', () async {
    expect((await datasource.getExamProgress(3)).total, 0);

    await datasource.saveExamProgress(3, 8, 10);

    final progress = await datasource.getExamProgress(3);
    expect(progress.correct, 8);
    expect(progress.total, 10);
  });
}

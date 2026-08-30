import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../core/services/database/database_config.dart';
import '../../../core/services/database/database_service.dart';
import '../../../domain/entities/learning_progress_entity.dart';
import '../interfaces/progress_datasource.dart';

class ProgressLocalDatasourceImpl implements ProgressDatasource {
  ProgressLocalDatasourceImpl(this._databaseService);

  final DatabaseService _databaseService;

  Database get _db => _databaseService.database;

  static const _progressTable = DatabaseConfig.learningProgressTableName;
  static const _examTable = DatabaseConfig.examProgressTableName;

  String _featureKey(ProgressFeature feature) => feature.name;

  String _statusKey(ProgressStatus status) => status.name;

  @override
  Future<LearningProgressEntity> getProgress(ProgressFeature feature, String scope) async {
    final rows = await _db.query(
      _progressTable,
      columns: ['itemId', 'status'],
      where: 'feature = ? AND scope = ?',
      whereArgs: [_featureKey(feature), scope],
    );

    final mastered = <String>{};
    final mistake = <String>{};

    for (final row in rows) {
      final itemId = row['itemId'] as String;

      if (row['status'] == _statusKey(ProgressStatus.mastered)) {
        mastered.add(itemId);
      } else if (row['status'] == _statusKey(ProgressStatus.mistake)) {
        mistake.add(itemId);
      }
    }

    return LearningProgressEntity(masteredIds: mastered, mistakeIds: mistake);
  }

  @override
  Future<void> recordMastered(ProgressFeature feature, String scope, String itemId) async {
    await _db.insert(_progressTable, {
      'feature': _featureKey(feature),
      'scope': scope,
      'itemId': itemId,
      'status': _statusKey(ProgressStatus.mastered),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> recordAnswer(ProgressFeature feature, String scope, String itemId, bool correct) async {
    if (correct) {
      await _db.delete(
        _progressTable,
        where: 'feature = ? AND scope = ? AND itemId = ? AND status = ?',
        whereArgs: [_featureKey(feature), scope, itemId, _statusKey(ProgressStatus.mistake)],
      );

      return;
    }

    await _db.insert(_progressTable, {
      'feature': _featureKey(feature),
      'scope': scope,
      'itemId': itemId,
      'status': _statusKey(ProgressStatus.mistake),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> clearMastered(ProgressFeature feature, String scope) async {
    await _db.delete(
      _progressTable,
      where: 'feature = ? AND scope = ? AND status = ?',
      whereArgs: [_featureKey(feature), scope, _statusKey(ProgressStatus.mastered)],
    );
  }

  @override
  Future<ExamProgressEntity> getExamProgress(int lesson) async {
    final rows = await _db.query(_examTable, where: 'lesson = ?', whereArgs: [lesson], limit: 1);

    if (rows.isEmpty) {
      return ExamProgressEntity(lesson: lesson);
    }

    final row = rows.first;

    return ExamProgressEntity(
      lesson: lesson,
      correct: (row['correct'] as num?)?.toInt() ?? 0,
      total: (row['total'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<void> saveExamProgress(int lesson, int correct, int total) async {
    await _db.insert(_examTable, {
      'lesson': lesson,
      'correct': correct,
      'total': total,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> clearExamProgress(int lesson) async {
    await _db.delete(_examTable, where: 'lesson = ?', whereArgs: [lesson]);
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../domain/entities/exam_lesson_entity.dart';
import '../../models/exam_lesson_model.dart';
import '../interfaces/exam_datasource.dart';

class ExamAssetDatasourceImpl implements ExamDatasource {
  static const _totalLessons = 25;

  final Map<int, ExamLessonEntity> _cache = {};

  String _assetPath(int lesson) => 'assets/data/exam/n5/lesson-${lesson.toString().padLeft(2, '0')}.json';

  @override
  Future<List<int>> getAvailableLessons() async {
    final result = <int>[];

    for (var lesson = 1; lesson <= _totalLessons; lesson++) {
      final data = await getLesson(lesson);

      if (data != null && data.questions.isNotEmpty) {
        result.add(lesson);
      }
    }

    return result;
  }

  @override
  Future<ExamLessonEntity?> getLesson(int lesson) async {
    if (_cache.containsKey(lesson)) return _cache[lesson];

    try {
      final raw = await rootBundle.loadString(_assetPath(lesson));
      final entity = ExamLessonModel.fromJson(json.decode(raw) as Map<String, dynamic>).toEntity();
      _cache[lesson] = entity;

      return entity;
    } on FlutterError {
      return null;
    }
  }
}

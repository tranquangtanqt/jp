import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../domain/entities/kanji_entity.dart';
import '../../../domain/entities/learning_category_entity.dart';
import '../../../domain/entities/radical_entity.dart';
import '../../models/kanji_model.dart';
import '../../models/learning_category_model.dart';
import '../../models/radical_model.dart';
import '../interfaces/kanji_datasource.dart';

class KanjiAssetDatasourceImpl implements KanjiDatasource {
  static const _categoriesPath = 'assets/data/kanji/categories.json';
  static const _n5Path = 'assets/data/kanji/n5.json';
  static const _radicalsPath = 'assets/data/kanji/radicals.json';

  List<KanjiEntity>? _kanjiCache;
  List<RadicalEntity>? _radicalsCache;

  Future<List<T>> _loadList<T>(String path, T Function(Map<String, dynamic>) mapper) async {
    final raw = await rootBundle.loadString(path);
    final list = json.decode(raw) as List;

    return list.map((e) => mapper(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<LearningCategoryEntity>> getCategories() async {
    final models = await _loadList(_categoriesPath, LearningCategoryModel.fromJson);

    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<KanjiEntity>> getKanjiByCategory(String categoryId) async {
    _kanjiCache ??= (await _loadList(_n5Path, KanjiModel.fromJson)).map((e) => e.toEntity()).toList();

    return _kanjiCache!.where((k) => k.categoryId == categoryId).toList();
  }

  @override
  Future<List<RadicalEntity>> getRadicals() async {
    _radicalsCache ??= (await _loadList(_radicalsPath, RadicalModel.fromJson)).map((e) => e.toEntity()).toList();

    return _radicalsCache!;
  }
}
